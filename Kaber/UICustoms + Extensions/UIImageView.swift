//
//  UIImageView.swift
//  Kaber
//
//  Created by Mohamed Ali on 16/08/2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    var placeholderImage: String {
        return images.loadingImage.name
    }
    
    var errorInConnection: String {
        return images.loadingImage.name
    }
    
    func loadImageFromServer(_ url: String, placeHolderName: String = images.loadingImage.name) {
        guard let url = URL(string: url) else { return }
        
        KF.url(url)
          .placeholder(UIImage(named: placeHolderName))
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.25)
          .onFailure { [weak self] _ in
              guard let self = self else { return }
              
              self.image = UIImage(named: errorInConnection)
          }
          .set(to: self)
    }
}
