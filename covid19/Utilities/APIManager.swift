//
//  APIManager.swift
//  covid19
//
//  Created by Jeevan on 29/04/21.
//

import Foundation
import Network

/// Handles HTTP Networking requests
class APIManager {
    private init() {} // Making the class a singleton
    public static let shared = APIManager() // Single shared instance
    let dataManager: DataManager = DataManager()
}

// MARK: Exposed HTTP Methods
extension APIManager {
    /// HTTP GET method
    ///  - Parameters:
    ///     - url: The url of the API to be invoked
    ///     - headers: All HTTP header fields
    ///     - success: Decodable response modal in case of API success
    ///     - failure: Decodable response modal in case of API failure - should conform to APIData protocol
    ///     - completion: Escaping closure with Swift.Result as closure parameter
    public func GET<S,F>(url: URL, headers: [String: String]? = nil, success: S.Type, failure: F.Type, _ completion: @escaping (Result<S, ServiceError>) -> Void) where S: Decodable, F: APIData {
        let request = dataManager.configureRequest(url: url, httpMethod: .GET, headers: headers)
        self.makeURLRequest(request, success: success, failure: failure) { (result) in
            switch result {
            case .success(let successModel):
                completion(.success(successModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: Helper methods
extension APIManager {
    /// Makes a HTTP URL request using the URLSession's data task
    /// - Parameters:
    ///     - request: request object containing the url, httpHeaders, queryParams, httpMethod
    ///     - success: Decodable response modal in case of API success
    ///     - failure: Decodable response modal in case of API failure - should conform to APIData protocol
    ///     - completion: Escaping closure with Swift.Result as closure parameter
    private func makeURLRequest<S,F>(_ request: URLRequest, success: S.Type, failure: F.Type, _ completion: @escaping (Result<S, ServiceError>) -> Void) where S: Decodable, F: APIData {
        
        let task = URLSession.shared.dataTask(with: request) { (data, rawResponse, apiServiceError) in
            self.dataManager.parseResponse(request, success: success, failure: failure, data: data, rawResponse: rawResponse, apiServiceError: apiServiceError) { (result) in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let successModel):
                    completion(.success(successModel))
                }
            }
        }
        task.resume()
    }
}
