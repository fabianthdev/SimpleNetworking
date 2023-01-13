//
//  ApiError.swift
//  SimpleNetworking
//
//  Created by Fabian Thies on 13.01.23.
//

import Foundation

public protocol ApiError: Codable {}

struct DefaultApiError: ApiError {
    let errorMessage: String
}
