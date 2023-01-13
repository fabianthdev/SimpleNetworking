//
//  ApiService.swift
//  SimpleNetworking
//
//  Created by Fabian Thies on 07.03.21.
//

import Foundation

public protocol ApiService {
    typealias ApiEmptyResponse = EmptyNetworkServiceResponse
    typealias FailureHandler = (Error) -> Void
}

public extension ApiService {
    
    static func request<T: Decodable>(resource: NetworkResource) async throws -> T {
        try await NetworkService.shared.request(resource: resource)
    }
}
