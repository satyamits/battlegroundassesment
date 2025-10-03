//
//  WorkoutParserRouter.swift
//  BattleGroundAssement
//
//  Created by Assistant on 21/09/25.
//

import Foundation
import UIKit

enum WorkoutParserRouter: Router {
    // Default filename updated to "image.jpeg"
    case parseImage(imageData: Data, typeID: Int, subtypeID: Int, mimeType: String = "image/jpeg", fileName: String = "image.jpeg")
    case parseText(text: String, typeID: Int, subtypeID: Int)

    var method: HTTPMethod {
        .post
    }

    var path: String {
        switch self {
        case .parseImage:
            return "/api/v1/sessions/parse-image/"
        case .parseText:
            return "/api/v1/sessions/parse-text/"
        }
    }

    var baseUrl: URL {
        return URL(string: "https://hyxpro.com")!
    }

    var queryParameters: [String : String]? { nil }
    var params: Any? { nil }
    var encodableBody: Encodable? { nil }
    var timeoutInterval: TimeInterval? { 60 }
    var keypathToMap: String? { nil }
    var requiresAuth: Bool { true }

    func urlRequest() throws -> URLRequest {
        let url = baseUrl.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let timeoutInterval { request.timeoutInterval = timeoutInterval }

        switch self {
        case .parseImage(let imageData, let typeID, let subtypeID, let mimeType, let fileName):
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var body = Data()
            body.appendMultipartFormField(named: "workout_type_id", value: String(typeID), using: boundary)
            body.appendMultipartFormField(named: "workout_subtype_id", value: String(subtypeID), using: boundary)
            body.appendMultipartFileField(named: "image", fileName: fileName, mimeType: mimeType, fileData: imageData, using: boundary)
            if let closing = "--\(boundary)--\r\n".data(using: .utf8) {
                body.append(closing)
            }
            request.httpBody = body

            #if DEBUG
            let contentType = request.value(forHTTPHeaderField: "Content-Type") ?? ""
            print("📦 Multipart Request -> \(request.httpMethod ?? "") \(url.absoluteString)")
            print("• Content-Type: \(contentType)")
            print("• Body size: \(body.count) bytes")
            print("• Fields: workout_type_id=\(typeID), workout_subtype_id=\(subtypeID)")
            if !imageData.isEmpty {
                print("• Image part: provided (\(imageData.count) bytes), name=image, filename=\(fileName), mime=\(mimeType)")
            } else {
                print("⚠️ Image data is EMPTY (0 bytes) — server will return 'No image file provided'.")
            }
            
            // Print first 500 bytes of multipart body for debugging
            let previewSize = min(500, body.count)
            if previewSize > 0 {
                let preview = body.subdata(in: 0..<previewSize)
                if let previewString = String(data: preview, encoding: .utf8) {
                    print("• Multipart body preview: \(previewString)")
                } else {
                    print("• Multipart body preview: [Binary data - first \(previewSize) bytes]")
                }
            }
            
            // Verify the multipart structure
            let bodyString = String(data: body, encoding: .utf8) ?? ""
            let hasCorrectBoundary = bodyString.contains("--\(boundary)")
            let hasFormFields = bodyString.contains("workout_type_id") && bodyString.contains("workout_subtype_id")
            let hasImageField = bodyString.contains("name=\"image\"")
            print("• Multipart validation: boundary=\(hasCorrectBoundary), formFields=\(hasFormFields), imageField=\(hasImageField)")
            #endif

        case .parseText(let text, let typeID, let subtypeID):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = [
                "text": text,
                "workout_type_id": typeID,
                "workout_subtype_id": subtypeID
            ]
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            #if DEBUG
            print("📝 JSON Request -> \(request.httpMethod ?? "") \(url.absoluteString)")
            if let bodyString = String(data: request.httpBody ?? Data(), encoding: .utf8) {
                print("• Body:", bodyString)
            }
            #endif
        }

        return request
    }
}

private extension Data {
    mutating func appendMultipartFormField(named name: String, value: String, using boundary: String) {
        let field = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(name)\"\r\n\r\n\(value)\r\n"
        if let data = field.data(using: .utf8) {
            append(data)
        }
    }

    mutating func appendMultipartFileField(named name: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) {
        let header = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\nContent-Type: \(mimeType)\r\n\r\n"
        if let headerData = header.data(using: .utf8) {
            append(headerData)
        }
        append(fileData)
        if let tail = "\r\n".data(using: .utf8) {
            append(tail)
        }
    }
}
