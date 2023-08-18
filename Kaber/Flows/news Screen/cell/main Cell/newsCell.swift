//
//  newsCell.swift
//  Kaber
//
//  Created by Mohamed Ali on 16/08/2023.
//

import UIKit
import RxSwift
import RxCocoa
import MOLH

class newsCell: UITableViewCell {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAuthorLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    var disposebag = DisposeBag()
    
    var readMoreButtonObservable: Observable<Void> {
        return readMoreButton.rx.tap.throttle(.microseconds(500), scheduler: MainScheduler.instance).asObservable()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        disposebag = DisposeBag()
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            descriptionLabel.textAlignment = .left
        }
        else {
            descriptionLabel.textAlignment = .right
        }
    }
    
    
    func configureCell(_ model: ArticleModel) {
        articleTitleLabel.text  = model.title
        articleAuthorLabel.text = model.author ?? "unknown"
        descriptionLabel.text   = model.description
        
        let publishAtDate = model.publishedAt.dateFromString()
        let hours = publishAtDate.hoursDifference()
        if hours >= 24 {
            publishDateLabel.text   = "\(hours/24)d"
        }
        else {
            publishDateLabel.text   = "\(hours)h"
        }
        
        if model.connection != nil {
            guard let data = model.urlToImageData else {
                articleImageView.image = images.loadingImage.image
                return
            }
            
            articleImageView.image = UIImage(data: data)
        }
        else {
            guard let imageUrl = model.urlToImage else { return }
            
            DispatchQueue.main.async { [weak self]  in
                guard let self = self else { return }
                
                articleImageView.loadImageFromServer(imageUrl)
            }
        }
         
        
    }
}
