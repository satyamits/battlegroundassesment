//
//  APILogger.swift
//  Hyxpro-fitness-app
//
//  Created by Satyam on 08/07/25.
//

import Foundation

final class APILogger {
    
    static let shared = APILogger()
    var enableLogs: Bool

    private init() {
        #if DEBUG || RELEASE
        enableLogs = true
        #else
        enableLogs = false
        #endif
    }

    func logRequest(_ request: URLRequest, body: Any?) {
//        guard enableLogs else { return }
        print("\n📤 REQUEST for: \(request.url?.absoluteString ?? "nil")")
        print("🧭 Method: \(request.httpMethod ?? "nil")")
        print("📦 Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        if let body = body {
            if let data = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted]),
               let json = String(data: data, encoding: .utf8) {
                print("📝 Body: \(json)")
            } else {
                print("📝 Body: \(body)")
            }
        } else if let httpBody = request.httpBody {
            let contentType = request.value(forHTTPHeaderField: "Content-Type") ?? ""
            if contentType.contains("multipart/form-data") {
                print("📝 Multipart Body: \(httpBody.count) bytes")
                // Show first 200 bytes for debugging
                let previewSize = min(200, httpBody.count)
                if previewSize > 0 {
                    let preview = httpBody.subdata(in: 0..<previewSize)
                    if let previewString = String(data: preview, encoding: .utf8) {
                        print("📝 Body preview: \(previewString)")
                    }
                }
            } else {
                print("📝 Body: \(httpBody.count) bytes")
            }
        }
    }

    func logSuccess(_ request: URLRequest, response: HTTPURLResponse, data: Data) {
//        guard enableLogs else { return }
        print("\n✅ [RESPONSE - SUCCESS]")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Status Code: \(response.statusCode)")

        printPayload(data)
    }

    func logError(_ request: URLRequest, response: HTTPURLResponse, data: Data) {
//        guard enableLogs else { return }
        print("\n❌ [RESPONSE - ERROR]")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Status Code: \(response.statusCode)")

        printPayload(data)
    }

    private func printPayload(_ data: Data) {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("📄 Payload:\n\(jsonString)")
        } else if let raw = String(data: data, encoding: .utf8) {
            print("📄 Raw Response: \(raw)")
        } else {
            print("📄 Payload: <Unable to parse data>")
        }
    }
}
