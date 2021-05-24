//
//  Endpoint.swift
//  URLSessionAPI
//
//  Created by Unal Celik on 21.05.2021.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "DELETE"
    // ... etc
}

public enum Endpoints {
    case photoOfToday
    case photoOfDate(date: Date)

    public var request: URLRequest? {
        guard let url = self.url else { return nil }
        var req = URLRequest(url: url)
        for (key,value) in headers {
            req.setValue(value, forHTTPHeaderField: key)
        }
        return req
    }

    public var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nasa.gov"
        components.path = path
        components.queryItems = parameters?.compactMap({ URLQueryItem(name: $0.key, value: $0.value)})
        return components.url
    }

    var path: String {
        switch self {
        case .photoOfToday:
            return "/planetary/apod"
        case .photoOfDate(let date):
            return "/planetary/apod/\(date)"
        }
    }

    var parameters: [String : String]? {
        return ["api_key":"DEMO_KEY"]
    }

    var headers: [String : String] {
        return [:]
    }

    var method: HTTPMethod {
        switch self {
        case .photoOfDate:
            return .post
        default:
            return .get
        }
    }
}
