//
//  GenericNetworkResource.swift
//  SimpleNetworking
//
//  Created by Fabian Thies on 13.01.23.
//

import Foundation

enum GenericNetworkResource: NetworkResource {
    case get(url: URL, headers: [String: String]? = nil)
    case post(url: URL, headers: [String: String]? = nil, parameters: [String: Any]? = nil)

    var baseURL: URL {
        switch self {
        case .get(let url, _), .post(let url, _, _):
            return url
        }
    }

    var path: String {
        ""
    }

    var httpMethod: HttpMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        }
    }

    var headers: [String : String] {
        switch self {
        case .get(_, let headers), .post(_, let headers, _):
            return headers ?? [:]
        }
    }

    var parameters: [String : Any] {
        switch self {
        case .post(_, _, let parameters):
            return parameters ?? [:]
        default:
            return [:]
        }
    }

    var parameterEncoding: ParameterEncoding {
        .json
    }
}
