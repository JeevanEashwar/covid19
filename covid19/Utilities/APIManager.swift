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
    
    // Making the class a singleton
    private init() {
        
    }
    public static let shared = APIManager()
    public var shouldPrintAPIsInConsole: Bool = true
    let successRange: ClosedRange<Int> = 200...399
}

extension APIManager {
    public func GET<S,F>(url: URL, headers: [String: String]? = nil, success: S.Type, failure: F.Type, _ completion: @escaping (Result<S, CustomError>) -> Void) where S: Decodable, F: APIData {
        let request = self.configureRequest(url: url, httpMethod: .GET, headers: headers)
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

extension APIManager {
    private func makeURLRequest<S,F>(_ request: URLRequest, success: S.Type, failure: F.Type, _ completion: @escaping (Result<S, CustomError>) -> Void) where S: Decodable, F: APIData {
        if let url = request.url, shouldPrintAPIsInConsole {
            print("\n------------------------------------------------------------------")
            print("\n------------------------------------------------------------------")
            print("API Requested: \(url.absoluteString)")
            print("\n------------------------------------------------------------------")
            print("\n------------------------------------------------------------------")
        }
        if let headers = request.allHTTPHeaderFields, shouldPrintAPIsInConsole {
            print("HTTP Request Headers: \n \(headers)\n")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, rawResponse, apiServiceError) in
            self.parseResponse(request, success: success, failure: failure, data: data, rawResponse: rawResponse, apiServiceError: apiServiceError) { (result) in
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
    
    private func parseResponse<S,F>(_ request: URLRequest, success: S.Type, failure: F.Type, data: Data?, rawResponse: URLResponse?, apiServiceError: Error?, _ completion: @escaping (Result<S, CustomError>) -> Void) where S: Decodable, F: APIData {
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
            let result = serializeDictionary([String: Any]())
            if let data = result.0 {
                dataToDecode = data
            } else if let parseError = result.1 {
                completion(.failure(.parsingError(parseError)))
            }
        }
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
    
    private func serializeDictionary(_ parameters: [String: Any]) -> (Data?, ParseError?) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            return (jsonData, nil)
        } catch {
            return (nil, ParseError(statusCode: -1, debugMessage: "JSON Serialization error"))
        }
    }
    
    private func configureRequest(url: URL, httpMethod: HTTPMethod, headers: [String: String]?, httpBody: Data? = nil, queryParams: [String: Any]? = nil) -> URLRequest {
        
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
        return request
    }
    
}

extension APIManager {
    public enum CustomError: Error {
        case parsingError(_ error: ParseError)
        case apiFailureError(_ error: Error)
    }
}

public struct ParseError: APIData {
    public var statusCode: Int
    public var debugMessage: String
}

public struct EmptySuccess: Codable {
    public init() {
        
    }
}

public protocol APIData: Decodable, Swift.Error {
    var statusCode: Int { get set }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

