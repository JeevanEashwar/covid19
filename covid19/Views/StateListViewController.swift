//
//  StateListViewController.swift
//  covid19
//
//  Created by Jeevan on 29/04/21.
//

import UIKit

class StateListViewController: UIViewController {
    
    var spinner : UIView?
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    @IBOutlet weak var stateListTableView: UITableView!
    
    let cellIdentifier = String(describing: StateTableViewCell.self)
    
    var viewModel: StateListViewModel = StateListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
        setUpTableView()
        viewModel.getCovidData()
    }
    
    private func bindViewModel() {
        viewModel.reloadUI = {
            DispatchQueue.main.async {
                self.stateListTableView.reloadData()
                self.lastUpdatedDateLabel.text = "COVID-19 INDIA as on: \(Date().formattedDate())"
            }
        }
        viewModel.handleAPIError = { (error) in
            
        }
        
        viewModel.updateIndicatorView = { (flag) in
            DispatchQueue.main.async {
                if flag {
                    self.showSpinner(onView: self.view)
                } else {
                    self.removeSpinner()
                }
            }
        }
    }
    
    private func setUpTableView() {
        stateListTableView.dataSource = self
        let nib = UINib(nibName: cellIdentifier, bundle: nibBundle)
        stateListTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    @IBAction func reloadData(_ sender: Any) {
        viewModel.getCovidData()
    }
}


extension StateListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfStates()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StateTableViewCell {
            cell.configure(viewModel: viewModel.stateObjectAt(index: indexPath.row))
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension StateListViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.startAnimating()
        indicatorView.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(indicatorView)
            onView.addSubview(spinnerView)
        }
        
        spinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.spinner?.removeFromSuperview()
            self.spinner = nil
        }
    }
}
