//
//  File.swift
//  SimpleNetworking
//
//  Created by Fabian Thies on 13.01.23.
//

import Foundation

public protocol AuthTokenProviding {
    var accessToken: String { get set }
    var refreshToken: String { get set }
}
