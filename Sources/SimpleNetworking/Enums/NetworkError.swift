//
//  NetworkError.swift
//  SimpleNetworking
//
//  Created by Fabian Thies on 13.01.23.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidResponse,
         httpError(statusCode: Int, content: String),
         noResponseData(statusCode: Int),
         invalidResponseData(statusCode: Int, decodeError: Error)
    
    case apiError(apiError: ApiError)
}
