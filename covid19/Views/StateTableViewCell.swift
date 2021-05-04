//
//  StateTableViewCell.swift
//  covid19
//
//  Created by Jeevan on 04/05/21.
//

import UIKit

class StateTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var stateMapImageView: UIImageView!
    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var active: UILabel!
    @IBOutlet weak var recovered: UILabel!
    @IBOutlet weak var deaths: UILabel!
    
    func configure(viewModel: StateViewModel?) {
        stateMapImageView.setCardLook()
        cardView.setCardLook()
        stateName.text = viewModel?.stateName
        active.text = viewModel?.activeCases
        recovered.text = viewModel?.recoveredCases
        deaths.text = viewModel?.deaths
        stateMapImageView.image = viewModel?.stateMapImage
    }
}
