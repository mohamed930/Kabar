//
//  UIViewController.swift
//  store
//
//  Created by Mohamed Ali on 23/07/2023.
//

import UIKit
import ProgressHUD

extension UIViewController {
    
    func showLoading() {
        ProgressHUD.show(myStrings.pleaseWait, interaction: false)
    }

    func dismissLoading() {
        ProgressHUD.dismiss()
    }
    
    func changeFontForNavigationController() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Blinker" , size: 22)!]
    }
}
