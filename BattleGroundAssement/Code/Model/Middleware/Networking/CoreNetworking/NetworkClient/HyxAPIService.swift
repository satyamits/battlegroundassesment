//
//  HyxAPIService.swift
//  Hyxpro-fitness-app
//
//  Created by Satyam on 08/07/25.
//

import Foundation

protocol APIServiceProtocol {
    func request<T: Decodable>(_ router: Router, responseType: T.Type) async throws -> T
}

final class HyxAPIService: APIServiceProtocol {
    
    static let shared = HyxAPIService()
    private let urlSession: URLSession
    private let reachability: NetworkReachability
    
    init(
        urlSession: URLSession = .shared,
        reachability: NetworkReachability = DefaultReachability()
    ) {
        self.urlSession = urlSession
        self.reachability = reachability
    }
    
    func request<T: Decodable>(_ router: Router, responseType: T.Type) async throws -> T {
        try await perform(router, responseType: T.self, allowRefresh: true)
    }
    
    private func perform<T: Decodable>(_ router: Router, responseType: T.Type, allowRefresh: Bool) async throws -> T {
        guard reachability.isReachable else { throw NetworkError.noInternet }
        
        var request = try router.urlRequest()
        
        if let timeout = router.timeoutInterval, timeout > 0 {
            request.timeoutInterval = timeout
        }
        
        if router.requiresAuth, let token = DataModel.shared.authToken {
            request.addAuthorization(withToken: token)
        }
        
        APILogger.shared.logRequest(request, body: router.params ?? router.encodableBody)
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
            
            if (200...299).contains(http.statusCode) {
                APILogger.shared.logSuccess(request, response: http, data: data)
                return try decode(from: data, keyPath: router.keypathToMap, request: request, response: http)
            }
            
            // Handle expired token -> try refresh
            if http.statusCode == 401, accessTokenExpiredFlag(in: data) == true {
                guard allowRefresh else { throw NetworkError.unauthorized }
                do {
                    _ = try await TokenRefresher.shared.refresh(using: self)
                } catch {
                    throw NetworkError.unauthorized
                }
                return try await perform(router, responseType: T.self, allowRefresh: false)
            }
            
            APILogger.shared.logError(request, response: http, data: data)
            throw NetworkError.serverError(statusCode: http.statusCode, data: data)
            
        } catch {
            // Map URLError cases to NetworkError
            if let urlError = error as? URLError {
                switch urlError.code {
                case .timedOut:
                    throw NetworkError.requestTimeout
                case .notConnectedToInternet, .networkConnectionLost:
                    throw NetworkError.noInternet
                default:
                    throw error
                }
            }
            throw error
        }
    }
    
    fileprivate func performRefresh() async throws -> Tokens {
        guard let rt = DataModel.shared.refreshToken, !rt.isEmpty else {
            throw NetworkError.unauthorized
        }
        let router = UserRouter.refereshToken(refreshToken: rt)
        
        let request = try router.urlRequest()
        
        APILogger.shared.logRequest(request, body: nil)
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
            
            guard (200...299).contains(http.statusCode) else {
                APILogger.shared.logError(request, response: http, data: data)
                throw NetworkError.unauthorized
            }
            APILogger.shared.logSuccess(request, response: http, data: data)
            let tokens: Tokens = try decode(from: data, keyPath: router.keypathToMap, request: request, response: http)
            DataModel.shared.authToken = tokens.accessToken
            return tokens
        } catch {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .timedOut:
                    throw NetworkError.requestTimeout
                case .notConnectedToInternet, .networkConnectionLost:
                    throw NetworkError.noInternet
                default:
                    throw error
                }
            }
            throw error
        }
    }
    
    private func accessTokenExpiredFlag(in data: Data) -> Bool {
        (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["access_token_expired"] as? Bool ?? false
    }
    
    func decode<T: Decodable>(from data: Data, keyPath: String?, request: URLRequest, response: HTTPURLResponse, decoder: JSONDecoder = .init()) throws -> T {
        // Configure a flexible date strategy to tolerate strings and numbers
        configureFlexibleDateDecoding(on: decoder)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        if let keyPath = keyPath,
           let dict = json as? [String: Any],
           let nested = dict.valueForKeyPath(keyPath) {
            let nestedData = try JSONSerialization.data(withJSONObject: nested, options: [])
            
            do {
                return try decoder.decode(T.self, from: nestedData)
            } catch let decodingError as DecodingError {
                print("❌ Decoding error: \(decodingError.localizedDescription)")
                
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("Coding path:", context.codingPath)
                case .valueNotFound(let type, let context):
                    print("Value '\(type)' not found:", context.debugDescription)
                    print("Coding path:", context.codingPath)
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("Coding path:", context.codingPath)
                case .dataCorrupted(let context):
                    print("Data corrupted:", context.debugDescription)
                    print("Coding path:", context.codingPath)
                @unknown default:
                    print("Unknown decoding error:", decodingError)
                }
                
                throw NetworkError.decodingError(decodingError)
            }
            
        } else {
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                APILogger.shared.logError(request, response: response, data: data)
                print("❌ Fallback decoding failed: \(error.localizedDescription)")
                throw NetworkError.decodingError(error)
            }
        }
    }

    // Allow the backend to send dates as seconds/millis or strings (ISO, plain)
    private func configureFlexibleDateDecoding(on decoder: JSONDecoder) {
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            // Try Double seconds
            if let seconds = try? container.decode(Double.self) {
                return Date(timeIntervalSince1970: seconds)
            }
            // Try Int millis
            if let millis = try? container.decode(Int.self) {
                return Date(timeIntervalSince1970: TimeInterval(millis) / 1000.0)
            }
            // Try String formats
            let s = try container.decode(String.self)
            if let d = ISO8601DateFormatter().date(from: s) { return d }
            let isoFrac = ISO8601DateFormatter()
            isoFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let d = isoFrac.date(from: s) { return d }
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = TimeZone(secondsFromGMT: 0)
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let d = df.date(from: s) { return d }
            let df2 = DateFormatter()
            df2.locale = Locale(identifier: "en_US_POSIX")
            df2.timeZone = TimeZone(secondsFromGMT: 0)
            df2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let d = df2.date(from: s) { return d }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported date format: \(s)")
        }
    }
    
    actor TokenRefresher {
        static let shared = TokenRefresher()
        private var inFlight: Task<Tokens, Error>?

        func refresh(using service: HyxAPIService) async throws -> Tokens {
            if let task = inFlight { return try await task.value }
            let task = Task<Tokens, Error> {
                defer { Task { self.clear() } }
                return try await service.performRefresh()
            }
            inFlight = task
            return try await task.value
        }

        private func clear() { inFlight = nil }
    }

}

