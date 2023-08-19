//
//  newsDetailsViewController.swift
//  Kaber
//
//  Created by Mohamed Ali on 17/08/2023.
//

import UIKit
import RxSwift
import MOLH

class newsDetailsViewController: UIViewController {
    
    // MARK:  - IBOutlets Here:
    @IBOutlet weak var authorTitleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var articleImageView:UIImageView!
    @IBOutlet weak var articleTitleLabel:UILabel!
    @IBOutlet weak var articleDescribtionLabel:UILabel!
    @IBOutlet weak var readMoreButton:UIButton!
        
        
    // MARK: - variables Here:
    var newsdetailsviewmodel: newsDetailsViewModel!
    let disposebag = DisposeBag()
    private var articleUrl: String!
    var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI methods.
        configureUI()
                
        // Bind methods.
        
        
        // Subscribe methods.
        subscribeToShowArticleDetailsBehaviour()
        
        
        // Action button methods.
        subscribeToReadMoreButtonAction()
        subscribeToShareButtonAction()

        
    }
    
    // MARK:  - Methods that handle UI Element in UI.
    // -------------------------------------------
    
    func configureUI() {
        navigationItem.title = myStrings.details
        navigationController?.isNavigationBarHidden = false
        
        readMoreButton.setTitle(myStrings.readMore, for: .normal)
        
        // Create a custom view to hold the button
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)) // You can adjust the size as needed

        // Create the button
        shareButton = UIButton(type: .custom)
        shareButton.setImage(images.share.image, for: .normal)
        shareButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24) // Button size
        shareButton.center = CGPoint(x: customView.bounds.midX, y: customView.bounds.midY)

        // Add the button to the custom view
        customView.addSubview(shareButton)

        // Create a bar button item with the custom view
        let barButtonItem = UIBarButtonItem(customView: customView)

        // Add the bar button item to the right side of the navigation bar
        navigationItem.rightBarButtonItem = barButtonItem
        
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            dateLabel.textAlignment = .left
            articleTitleLabel.textAlignment = .left
            articleDescribtionLabel.textAlignment = .left
        }
        else {
            dateLabel.textAlignment = .right
            articleTitleLabel.textAlignment = .right
            articleDescribtionLabel.textAlignment = .right
        }
    }

    // -------------------------------------------


    // MARK:  - Methods that handle bind UI variable to his rxSwift variables in ViewModel.
    // -------------------------------------------

    // -------------------------------------------

    // MARK: -  Methods that handle the Subscribe of variables in ViewModel Class.
    // -------------------------------------------
    
    func subscribeToShowArticleDetailsBehaviour() {
        newsdetailsviewmodel.articleBehaviour.asObservable().subscribe(onNext: { [unowned self] article in
            
            guard let article = article else { return }
            
            articleTitleLabel.text       = article.title
            articleDescribtionLabel.text = article.description
            
            articleUrl = article.url
                    
            authorTitleLabel.text = article.author ?? "Unkown"
            
            let publishAtDate = article.publishedAt.dateFromString()
            let hours = publishAtDate.hoursDifference()
            if hours >= 24 {
                dateLabel.text   = "\(hours/24)d ago"
            }
            else {
                dateLabel.text   = "\(hours)h ago"
            }
            
            if article.connection ?? true {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    articleImageView.loadImageFromServer(article.urlToImage ?? "")
                }
            }
            else {
                guard let img = article.urlToImageData else {
                    articleImageView.image = images.loadingImage.image
                    return
                }
                articleImageView.image = UIImage(data: img)
            }
            
        }).disposed(by: disposebag)
    }

    // -------------------------------------------

    // MARK: - Methods that handle Button Actions in the UI.
    // -------------------------------------------
    
    func subscribeToReadMoreButtonAction() {
        readMoreButton.rx.tap.throttle(.microseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] _ in
            
            openArticleOperaion(articleUrl: articleUrl)
        }).disposed(by: disposebag)
    }
    
    func subscribeToShareButtonAction() {
        shareButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] _ in
            newsdetailsviewmodel.showShareSheet(ob: self)
        }).disposed(by: disposebag)
    }

    // -------------------------------------------

    // MARK: - Assists Methods.
    // -------------------------------------------

    // -------------------------------------------

}
