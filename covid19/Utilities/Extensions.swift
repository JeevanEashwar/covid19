//
//  Extensions.swift
//  covid19
//
//  Created by Jeevan on 04/05/21.
//

import Foundation
import UIKit

extension UIView {
    func setCardLook() {
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.7
    }
}

extension String {
    func numberFormat() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let number = Int(self) ?? 0
        return numberFormatter.string(from: NSNumber(value: number))
    }
}

extension Date {
    func formattedDate() -> String {
        let expectedFormat = "dd/MM/yyyy HH:mm Z"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = expectedFormat
        return dateFormatter.string(from: self)
    }
}
