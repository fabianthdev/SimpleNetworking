//
//  JSONDecoder+Api.swift
//  
//
//  Created by Fabian Thies on 13.01.23.
//

import Foundation

public extension JSONDecoder {

    static let snakeCaseDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return jsonDecoder
    }()
}
