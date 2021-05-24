//
//  NetworkManager.swift
//  URLSessionAPI
//
//  Created by Unal Celik on 21.05.2021.
//

import Foundation

public enum APIError: Error {
    case invalidURL
    case invalidData
    case invalidRequest
    case invalidResponse
    case badStatus(code: Int)
    case decodingError
    case serviceError(description: String?)

    public var description: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .invalidData:
            return "The data is invalid"
        case .invalidRequest:
            return "The request is invalid"
        case .invalidResponse:
            return "The response is invalid"
        case .decodingError:
            return "Decoding failed"
        case .badStatus(let statusCode):
            return "Bad status code: \(statusCode)"
        case .serviceError(let description):
            return "Service Error \(description)"
        }
    }
}

public typealias ResponseHandler<T: Decodable> = (Result<T, APIError>) -> Void

public class NetworkManager {

    public static let shared: NetworkManager = .init()

    private init() { }

    public func requestData<T: Decodable>(from endpoint: Endpoints,
                                          type: T.Type,
                                          completion: @escaping ResponseHandler<T>) {
        guard let request = endpoint.request else {
            completion(.failure(.invalidRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.serviceError(description: error.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard (200...299) ~= httpResponse.statusCode else {
                completion(.failure(.badStatus(code: httpResponse.statusCode)))
                return
            }

            if let data = data {
                do {
                    let decodedObject = try JSONDecoder().decode(type, from: data)
                    completion(.success(decodedObject))
                } catch (_) {
                    completion(.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
}


