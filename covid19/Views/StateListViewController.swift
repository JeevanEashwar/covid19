//
//  StateListViewController.swift
//  covid19
//
//  Created by Jeevan on 29/04/21.
//

import UIKit

class StateListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func callAPI(_ sender: Any) {
        guard let url = URL(string: "https://api.covid19india.org/data.json") else { return }
        APIManager.shared.GET(url: url, success: CovidData.self, failure: ParseError.self) { (result) in
            switch result {
            case .failure(let error):
                // TODO: error handling
                print(error.localizedDescription)
            case .success(let covidModel):
                print(covidModel)
            }
        }
    }
    
}

