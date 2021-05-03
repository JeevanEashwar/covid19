//
//  Utilities.swift
//  covid19Tests
//
//  Created by Jeevan on 02/05/21.
//

import Foundation
@testable import covid19

class SuccessRootAPIService: RootAPIServiceProtocol {
    func GET<S, F>(url: URL, headers: [String : String]?, success: S.Type, failure: F.Type, _ completion: @escaping (Result<S, ServiceError>) -> Void) where S : Decodable, F : APIData {
        let expectedType = String(describing: success)
        let dummyError = CustomError(statusCode: 100, debugMessage: "Could not find a stub for the given decodable \(expectedType)")
        switch expectedType {
        case String(describing: CovidData.self):
            if let covidDataModel = StubGenerator.getCovidData(success) {
                completion(.success(covidDataModel))
                return
            }
        default:
            completion(.failure(ServiceError.parsingError(dummyError)))
        }
        completion(.failure(ServiceError.parsingError(dummyError)))
    }
    
}

class FailureRootAPIService: RootAPIServiceProtocol {
    func GET<S, F>(url: URL, headers: [String : String]?, success: S.Type, failure: F.Type, _ completion: @escaping (Result<S, ServiceError>) -> Void) where S : Decodable, F : APIData {
        let dummyError = CustomError(statusCode: 100, debugMessage: "This is a forced error introduced by FailureRootAPIService")
        completion(.failure(ServiceError.parsingError(dummyError)))
    }
    
}

class StubGenerator {
    static func getCovidData<T: Decodable>(_ expectedReturnType: T.Type) -> T? {
        let testBundle = Bundle(for: self.self)
        guard let dataToDecode = StubGenerator.dataFromFile("CovidDataSampleResponse", ofType: "json", bundle: testBundle) else { return nil }
        do {
            let successModel = try JSONDecoder().decode(expectedReturnType, from: dataToDecode)
            return successModel
        } catch (let error) {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private static func dataFromFile(_ name: String, ofType type: String, bundle: Bundle) -> Data? {
        guard let path = bundle.path(forResource: name, ofType: type) else {
            return nil
        }
        if let fileData = NSData(contentsOfFile: path) {
            return fileData as Data
        }
        return nil
    }
}
