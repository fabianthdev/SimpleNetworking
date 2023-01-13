//
//  NetworkResource.swift
//  SimpleNetworking
//
//  Created by Fabian Thies on 07.03.21.
//

import Foundation

public protocol NetworkResource {

    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    var parameterEncoding: ParameterEncoding { get }

    var requiresAuth: Bool { get }
    var jsonDecoder: JSONDecoder { get }
}

public extension NetworkResource {

    var urlRequest: URLRequest {
        var path = self.path
        if path.first == "/" {
            path.removeFirst()
        }
        var url = self.baseURL.appendingPathComponent(path)

        if self.httpMethod == .get, !self.parameters.isEmpty {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                assert(false, "Invalid url")
                return URLRequest(url: url)
            }

            urlComponents.queryItems = self.parameters.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
            url = urlComponents.url ?? url
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = self.headers

        if self.requiresAuth, let authTokenProvider = NetworkService.shared.authTokenProvider?() {
            let authHeader = ["Authorization": "Bearer \(authTokenProvider.accessToken)"]
            urlRequest.allHTTPHeaderFields?.merge(authHeader, uniquingKeysWith: { _, new in new })
        }

        if self.httpMethod != .get, !self.parameters.isEmpty {
            switch self.parameterEncoding {
            case .json:
                do {
                    let data = try JSONSerialization.data(withJSONObject: self.parameters, options: .sortedKeys)
                    urlRequest.httpBody = data
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    Logger.e("[NetworkResource] Could not convert parameters to data. Error:", error)
                }
            case .form:
                func percentEscape(_ object: Any) -> String {
                    let string = "\(object)"
                    let characterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-._* "))
                    return string
                        .addingPercentEncoding(withAllowedCharacters: characterSet)?
                        .replacingOccurrences(of: " ", with: "+") ?? string
                }
                let parameterString = self.parameters.map({ "\($0.key)=\(percentEscape($0.value))" }).joined(separator: "&")
                if let parameterData = parameterString.data(using: .utf8) {
                    urlRequest.httpBody = parameterData
                    urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                } else {
                    Logger.e("[NetworkResource] Could not convert parameters to form data.")
                }
            }
        }

        return urlRequest
    }

    // MARK: Default implementations
    var jsonDecoder: JSONDecoder {
        JSONDecoder.snakeCaseDecoder
    }

    var headers: [String: String] {
        [:]
    }

    var requiresAuth: Bool {
        false
    }
}
