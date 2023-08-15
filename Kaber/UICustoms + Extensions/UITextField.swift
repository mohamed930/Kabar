//
//  UITextField.swift
//  store
//
//  Created by Mohamed Ali on 23/07/2023.
//

import UIKit
import Combine

extension UITextField {
        
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addPadding(amount:CGFloat, PlaceHolder:String , Color: UIColor) {
        setLeftPaddingPoints(amount)
        setRightPaddingPoints(amount)
        
        self.attributedPlaceholder = NSAttributedString(string: PlaceHolder,
                attributes: [NSAttributedString.Key.foregroundColor: Color])
    }
}
