//
//  RootAPIService.swift
//  covid19
//
//  Created by Jeevan on 01/05/21.
//

import Foundation

public protocol RootAPIServiceProtocol: class {
    func GET<S: Decodable, F: APIData>(url: URL, headers: [String: String]?, success: S.Type, failure: F.Type, _ completion: @escaping (Result<S, ServiceError>) -> Void)
}

public class RootAPIService: RootAPIServiceProtocol {
    public init() { }
    
    public func GET<S, F>(url: URL, headers: [String : String]?, success: S.Type, failure: F.Type, _ completion: @escaping (Result<S, ServiceError>) -> Void) where S : Decodable, F : APIData {
        APIManager.shared.GET(url: url, success: S.self, failure: F.self) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let model):
                completion(.success(model))
            }
        }
    }
}
