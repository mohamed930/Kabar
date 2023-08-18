//
//  searchCell.swift
//  Kaber
//
//  Created by Mohamed Ali on 18/08/2023.
//

import UIKit
import MOLH

class searchCell: UITableViewCell {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAuthorNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            articleTitleLabel.textAlignment = .right
            articleAuthorNameLabel.textAlignment = .right
        }
        else {
            articleTitleLabel.textAlignment = .left
            articleAuthorNameLabel.textAlignment = .left
        }
        
    }
    
    func configureCell(_ model: ArticleModel) {
        articleTitleLabel.text          = model.title
        articleAuthorNameLabel.text     = model.source.name
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard let url = model.urlToImage else {
                articleImageView.image = images.loadingImage.image
                return
            }
            
            articleImageView.loadImageFromServer(url)
        }
    }
    
}
