//
//  CovidAPIService.swift
//  covid19
//
//  Created by Jeevan on 01/05/21.
//

import Foundation

typealias CovidNumbersCompletion = (Result<CovidData, ServiceError>) -> Void

protocol CovidAPIProtocol: class {
    func getCovidNumbers(completion: @escaping CovidNumbersCompletion)
}

class CovidAPIService: CovidAPIProtocol {
    let rootService: RootAPIServiceProtocol?
    init(rootService: RootAPIServiceProtocol = RootAPIService()) {
        self.rootService = rootService
    }
    
    func getCovidNumbers(completion: @escaping CovidNumbersCompletion) {
        /// curl --location --request GET 'https://api.covid19india.org/data.json'
        guard let url = URL(string: "https://api.covid19india.org/data.json") else { return }
        self.rootService?.GET(url: url, headers: nil, success: CovidData.self, failure: CustomError.self, { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let model):
                completion(.success(model))
            }
        })
    }
}
