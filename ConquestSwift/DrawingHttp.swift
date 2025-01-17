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

    func get(key: String) async throws -> Drawing? {
        var request = genURLRequest(path: "user-draws/key", method: "POST")
        let body = RequestBody(key: key)

        request.httpBody = try JSONEncoder().encode(body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            let canvasData = try JSONDecoder().decode(Drawing.self, from: data)

            return canvasData
        } catch { print(error)
            return nil
        }
    }

    func post(data: UserDrawingData) async throws {
        var request = genURLRequest(path: "user-draws", method: "POST")
        request.httpBody = try JSONEncoder().encode(data)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

        } catch { print(error) }
    }
}

struct RequestBody: Codable {
    let key: String
}
