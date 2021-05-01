//
//  DataManager.swift
//  covid19
//
//  Created by Jeevan on 01/05/21.
//

import Foundation

class DataManager {
    init() {}
    let shouldPrintAPIsInConsole: Bool = true // Flag to control API logs in the xcode console
    let successRange: ClosedRange<Int> = 200...399 // API success status code range
    
    /// Conditional parsing of the API response to respective Decodable objects before returning to the service class
    /// - Parameters:
    ///     - request: request object containing the url, httpHeaders, queryParams, httpMethod
    ///     - success: Decodable response modal in case of API success
    ///     - failure: Decodable response modal in case of API failure - should conform to APIData protocol
    ///     - data: Optional data to decode
    ///     - rawResponse: Optional param contains status code and raw response
    ///     - apiServiceError: Optional error object if the API service fails.
    ///     - completion: Escaping closure with Swift.Result as closure parameter
    func parseResponse<S,F>(_ request: URLRequest, success: S.Type, failure: F.Type, data: Data?, rawResponse: URLResponse?, apiServiceError: Error?, _ completion: @escaping (Result<S, CustomError>) -> Void) where S: Decodable, F: APIData {
        if let url = request.url, shouldPrintAPIsInConsole {
            print("\n------------------------------------------------------------------")
            print("\n------------------------------------------------------------------")
            print("API Response for: \(url.absoluteString)")
            print("\n------------------------------------------------------------------")
            print("\n------------------------------------------------------------------")
        }
        
        if let serviceError = apiServiceError, shouldPrintAPIsInConsole {
            print("HTTP service failed with error: \n\(String(describing: serviceError))")
        }
        
        if let nonOptionalData = data, let jsonString = String(bytes: nonOptionalData, encoding: .utf8), shouldPrintAPIsInConsole {
            print("HTTP response data: \n\(jsonString)\n")
        }
        
        if let rawResponse = rawResponse, shouldPrintAPIsInConsole {
            print("HTTP raw response: \n\(String(describing: rawResponse))")
            print("\n------------------------------------------------------------------")
            print("\n------------------------------------------------------------------")
        }
        
        guard let response = rawResponse as? HTTPURLResponse, (successRange).contains(response.statusCode) else {
            // Error scenarios
            let statusCode = (rawResponse as? HTTPURLResponse)?.statusCode ?? 0
            if let serviceError = apiServiceError {
                completion(.failure(.apiFailureError(ParseError(statusCode: statusCode, debugMessage: serviceError.localizedDescription))))
            } else {
                completion(.failure(.apiFailureError(ParseError(statusCode: statusCode, debugMessage: "Unknown API error"))))
            }
            return
        }
        
        var dataToDecode: Data?
        
        if let successData = data, !successData.isEmpty {
            dataToDecode = data
        } else if success == EmptySuccess.self && (data == nil || data?.isEmpty ?? true) {
            // This block is for accepting empty json as valid success scenario
            let result = serializeDictionary([String: Any]())
            if let data = result.0 {
                dataToDecode = data
            } else if let parseError = result.1 {
                completion(.failure(.parsingError(parseError)))
            }
        }
        
        // Decodes Data object to success modal object
        if let dataToDecode = dataToDecode {
            do {
                let successModel = try JSONDecoder().decode(success, from: dataToDecode)
                completion(.success(successModel))
            } catch let decodingError {
                completion(.failure(.parsingError(ParseError(statusCode: -2, debugMessage: decodingError.localizedDescription))))
            }
        } else {
            completion(.failure(.parsingError(ParseError(statusCode: -3, debugMessage: "No data success"))))
        }
    }
    
    /// Converts swift dictionary to data object using JSONSerialization
    /// - Parameter parameters: Input dictionary to be serialized
    private func serializeDictionary(_ parameters: [String: Any]) -> (Data?, ParseError?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            return (jsonData, nil)
        } catch {
            return (nil, ParseError(statusCode: -1, debugMessage: "JSON Serialization error"))
        }
    }
    
    /// Creates a URLRequest object from the inputs
    /// - Parameters:
    ///     - url: The url of the API to be invoked
    ///     - httpMethod: enumeration value of http method type (GET, POST etc)
    ///     - headers: Optional HTTP headers
    ///     - httpBody: Optional HTTP body
    ///     - queryParams: Optional query parameters to be appended to the url
    func configureRequest(url: URL, httpMethod: HTTPMethod, headers: [String: String]?, httpBody: Data? = nil, queryParams: [String: Any]? = nil) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        
        if let queryParams = queryParams {
            if var urlComponents = URLComponents(string: url.absoluteString) {
                urlComponents.queryItems = [URLQueryItem]()
                queryParams.forEach { (item) in
                    let queryItem = URLQueryItem(name: item.key, value: String(describing: item.value))
                    urlComponents.queryItems?.append(queryItem)
                }
                request.url = urlComponents.url
            }
        }
        
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        if shouldPrintAPIsInConsole {
            print("\n------------------------------------------------------------------")
            print("\n------------------------------------------------------------------")
            print("API Requested: \(url.absoluteString)")
            print("\n------------------------------------------------------------------")
            print("\n------------------------------------------------------------------")
        }
        if let headers = request.allHTTPHeaderFields, shouldPrintAPIsInConsole {
            print("HTTP Request Headers: \n \(headers)\n")
        }
        return request
    }
}
