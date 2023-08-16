//
//  newsCell.swift
//  Kaber
//
//  Created by Mohamed Ali on 16/08/2023.
//

import UIKit
import RxSwift
import RxCocoa

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
    }
    
    
    func configureCell(_ model: ArticleModel) {
        articleTitleLabel.text  = model.title
        articleAuthorLabel.text = model.author ?? "unknown"
        descriptionLabel.text   = model.description
        
        let hours = hoursDifference(from: dateFromString(model.publishedAt))
        if hours >= 24 {
            publishDateLabel.text   = "\(hours/24)d"
        }
        else {
            publishDateLabel.text   = "\(hours)h"
        }
        
        guard let imageUrl = model.urlToImage else { return }
         
        DispatchQueue.main.async { [weak self]  in
            guard let self = self else { return }
            
            articleImageView.loadImageFromServer(imageUrl)
        }
    }
    
    private func dateFromString(_ isoDate: String) -> Date{
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:isoDate)!
        
        return date
    }
    
    
    func hoursDifference(from date: Date) -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: date, to: currentDate)
        
        if let hours = components.hour {
            return hours
        }
        return 0 // Default value in case of an issue
    }
}
