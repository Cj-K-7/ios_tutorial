//
//  DrawingHttp.swift
//  ConquestSwift
//
//  Created by changju.kim on 1/10/25.
//
import Foundation

class DrawingHttpService {
    private let baseDomain: String = "https://drawing-service.testbank.ai"
    private let apiKey: String = "tbk-drawing-api1!"

    private let baseURL: URL

    init() {
        guard let initURL = URL(string: baseDomain) else {
            fatalError("URL string not valid")
        }

        self.baseURL = initURL
    }

    private func genURLRequest(path: String, method: String) -> URLRequest {
        let endPath = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: endPath)

        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "api-key")

        return request
    }

    func get() async throws -> Data {
        var request = genURLRequest(path: "user-draws/key", method: "POST")
        let body = RequestBody(key: "22842&a3a0e241-d52b-4b44-b0ad-685684735659&18570-1&1")

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        let stringfied = String(data: data, encoding: .utf8)

        return data
    }
}

struct RequestBody: Codable {
    let key: String
}
