//
//  UIView.swift
//  Kaber
//
//  Created by Mohamed Ali on 17/08/2023.
//

import UIKit

extension UIView {
    func updateBorderColor(colorName: String) {
        self.layer.borderColor = UIColor(named: colorName)!.cgColor
    }
}
