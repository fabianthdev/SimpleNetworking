//
//  NetworkService.swift
//  SimpleNetworking
//
//  Created by Fabian Thies on 07.03.21.
//

import UIKit

public class NetworkService {
    public typealias GetAuthTokenProviderHandler = () -> AuthTokenProviding
    public typealias RefreshTokenHandler = () async throws -> Void

    // MARK: Properties
    public static let shared = NetworkService()
    private var urlSession: URLSession = URLSession.shared
    private var activeTasks: Int = 0

    // MARK: Configuration Properties
    public var errorResponseModel: ApiError.Type = DefaultApiError.self
    public var errorResponseDecoder: JSONDecoder?
    public var authTokenProvider: GetAuthTokenProviderHandler?
    public var performTokenRefresh: RefreshTokenHandler?


    // MARK: Lifecycle
    private init() {}


    // MARK: Actions
    public func request<T: Decodable>(resource: NetworkResource) async throws -> T {
        self.activeTasks += 1
        let (data, response) = try await self.urlSession.data(for: resource.urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        if response.statusCode == 401, let performTokenRefresh {
            // Access token has to be refreshed
            Logger.i("The accessToken is invalid. Trying to refresh...")

            try await performTokenRefresh()

            Logger.i("The accessToken has been refreshed.")

            return try await self.request(resource: resource)
        }
        
        guard 200..<400 ~= response.statusCode else {
            let decoder = self.errorResponseDecoder ?? resource.jsonDecoder
            if let errorResponse = try? decoder.decode(self.errorResponseModel, from: data) {
                throw NetworkError.apiError(apiError: errorResponse)
            }

            let contentString = String(data: data, encoding: .utf8)
            throw NetworkError.httpError(statusCode: response.statusCode, content: contentString ?? "")
        }

        // handle http status code 204: No content
        if response.statusCode == 204, data.count == 0, T.self == EmptyNetworkServiceResponse.self, let returnValue = EmptyNetworkServiceResponse() as? T {
            return returnValue
        }

        guard data.count > 0 else {
            throw NetworkError.noResponseData(statusCode: response.statusCode)
        }

        if T.self == Data.self, let returnValue = data as? T {
            return returnValue
        }

        do {
            let responseObject = try resource.jsonDecoder.decode(T.self, from: data)
            return responseObject
        } catch {
            Logger.d(String(data: data, encoding: .utf8) ?? "no data")
            throw NetworkError.invalidResponseData(statusCode: response.statusCode, decodeError: error)
        }
    }
}
