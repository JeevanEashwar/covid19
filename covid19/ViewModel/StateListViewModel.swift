//
//  StateListViewModel.swift
//  covid19
//
//  Created by Jeevan on 03/05/21.
//

import Foundation

class StateListViewModel {
    
    var apiService: CovidAPIProtocol
    
    init(apiService: CovidAPIProtocol = CovidAPIService()) {
        self.apiService = apiService
    }
    
    var covidDataModel: CovidData?
    var reloadUI: (() -> Void)?
    var handleAPIError: ((_ error: ServiceError) -> Void)?
    var updateIndicatorView: ((_ flag: Bool) -> Void)?
    
    func getCovidData() {
        updateIndicatorView?(true)
        apiService.getCovidNumbers { (result) in
            self.updateIndicatorView?(false)
            switch result {
            case .success(let successModel):
                self.covidDataModel = successModel
                self.reloadUI?()
            case .failure(let error):
                self.handleAPIError?(error)
            }
        }
    }
    
    func numberOfStates() -> Int {
        return covidDataModel?.statewise.count ?? 0
    }
    
    func stateObjectAt(index: Int) -> StateViewModel? {
        if numberOfStates() > 0 && index < numberOfStates() {
            if let statewise = covidDataModel?.statewise[index] {
                return StateViewModel(statewise: statewise)
            }
        }
        return nil
    }
}
