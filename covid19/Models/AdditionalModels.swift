//
//  AdditionalModels.swift
//  covid19
//
//  Created by Jeevan on 01/05/21.
//

import Foundation

public protocol APIData: Decodable, Swift.Error {
    var statusCode: Int { get set }
}

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

public struct CustomError: APIData {
    public var statusCode: Int
    public var debugMessage: String
}

public enum ServiceError: Error {
    case parsingError(_ error: CustomError)
    case apiFailureError(_ error: Error)
}

public struct EmptySuccess: Codable {
    public init() {
        
    }
}
