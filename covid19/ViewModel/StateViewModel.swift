//
//  StateViewModel.swift
//  covid19
//
//  Created by Jeevan on 03/05/21.
//

import Foundation
import UIKit

class StateViewModel {
    
    var statewise: Statewise
    
    init(statewise: Statewise) {
        self.statewise = statewise
    }
    
    var activeCases: String {
        return statewise.active?.numberFormat() ?? ""
    }
    
    var recoveredCases: String {
        return statewise.recovered?.numberFormat() ?? ""
    }
    
    var deaths: String {
        return statewise.deaths?.numberFormat() ?? ""
    }
    
    var stateName: String {
        return statewise.state ?? ""
    }
    
    var stateMapImage: UIImage? {
        return UIImage(named: stateName)
    }
}
