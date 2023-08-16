//
//  UIViewController.swift
//  store
//
//  Created by Mohamed Ali on 23/07/2023.
//

import UIKit
import ProgressHUD
import SafariServices

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
    
    func openArticleOperaion(article: ArticleModel) {
        if let url = URL(string: article.url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
