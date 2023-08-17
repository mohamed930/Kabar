//
//  newsViewController.swift
//  Kaber
//
//  Created by Mohamed Ali on 15/08/2023.
//

import UIKit
import RxSwift
import MOLH

class newsViewController: UIViewController {

    // MARK:  - IBOutlets Here:
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var connectionBannerView:UIView!
       
    // MARK: - variables Here:
    var newsviewmodel: newsViewModel!
    let disposebag = DisposeBag()
    let paddingValue: CGFloat = 34
    let newsCellStr = "newsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI methods.
        configureUI()
        regesterTableView()
                
        // Bind methods.
        bindNewsBehaviourToTableView()
        
        
        // Subscribe methods.
        subscribeToInterConnectionRestore()
        subscribeToIsLoadingBehaviour()
        subscribeToSelectArticleTableView()
        
        
        // Action button methods.
        
        
        // Assits method.
    }
    
    // MARK:  - Methods that handle UI Element in UI.
    // -------------------------------------------
    
    func configureUI() {
        navigationController?.isNavigationBarHidden = false
//        navigationItem.title = MOLHLanguage.currentAppleLanguage() == "en" ? "news" : "الاخبار"
        navigationItem.title = myStrings.news
        self.changeFontForNavigationController()
        searchTextField.setLeftPaddingPoints(paddingValue)
        searchTextField.setRightPaddingPoints(paddingValue)
        searchTextField.attributedPlaceholder =
        NSAttributedString(string: myStrings.search, attributes: [NSAttributedString.Key.foregroundColor: images.bodyTextGrayScale.color])
    }
    
    func regesterTableView() {
        tableView.register(UINib(nibName: newsCellStr, bundle: nil), forCellReuseIdentifier: newsCellStr)
    }
    
    // -------------------------------------------
    
    
    // MARK:  - Methods that handle bind UI variable to his rxSwift variables in ViewModel.
    // -------------------------------------------
    
    func bindNewsBehaviourToTableView() {
        newsviewmodel.newsObservable.bind(to: tableView.rx.items(cellIdentifier: newsCellStr, cellType: newsCell.self)) { row,branch,cell in
            
            cell.configureCell(branch)
            
            cell.disposebag = DisposeBag()
            
            cell.readMoreButtonObservable.subscribe(onNext: { [unowned self] _ in
                
                openArticleOperaion(articleUrl: branch.url)
            }).disposed(by: cell.disposebag)
            
        }.disposed(by: disposebag)
    }
    
    // -------------------------------------------
    
    // MARK: -  Methods that handle the Subscribe of variables in ViewModel Class.
    // -------------------------------------------
    
    func subscribeToInterConnectionRestore() {
        let netowrk = NetworkManagerReachability()
        
        NetworkManagerReachability.sharedInstance.connectionBehaviour.asObservable().subscribe(onNext: { [weak self] isConnected in
            guard let self = self else { return }

            print(isConnected)
            
            NetworkManagerReachability.sharedInstance.reachability.whenReachable = { _ in
                NetworkManagerReachability.sharedInstance.connectionBehaviour.accept(true)
            }
            
            NetworkManagerReachability.sharedInstance.reachability.whenUnreachable = { _ in
                NetworkManagerReachability.sharedInstance.connectionBehaviour.accept(false)
            }

            if isConnected == true {
                // Connection is available
                print("Connected to the internet")
                connectionBannerView.isHidden = true
                fetchArticlesFromServer()

            } else {
                // No connection
                print("No internet connection")
                connectionBannerView.isHidden = false
                fetchArticlesFromLocalStorage()
            }
        }).disposed(by: disposebag)
        
//        NetworkManagerReachability.openNotifier()
        
//        let network = NetworkManagerReachability()
//
//        network.isReachable { [unowned self] _ in
//            connectionBannerView.isHidden = true
//            fetchArticlesFromServer()
//        }
//
//        network.isUnreachable { [unowned self] _ in
//            connectionBannerView.isHidden = false
//            fetchArticlesFromLocalStorage()
//        }
    }
    
    func subscribeToIsLoadingBehaviour() {
        newsviewmodel.isloadingBehaviour.subscribe(onNext: { [weak self] isloading in
            guard let self = self else { return }
            
            if isloading {
                showLoading()
            }
            else {
                dismissLoading()
            }
            
        }).disposed(by: disposebag)
    }
    
    func subscribeToSelectArticleTableView() {
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(ArticleModel.self).throttle(.milliseconds(500), scheduler: MainScheduler.instance))
           .bind { [weak self] selectedIndex, branch in

           guard let self = self else { return }
               
           newsviewmodel.moveToNewsDetailsOperation(article: branch)
               
       }.disposed(by: disposebag)
    }
    
    // -------------------------------------------
    
    // MARK: - Methods that handle Button Actions in the UI.
    // -------------------------------------------
    
    // -------------------------------------------
    
    // MARK: - Assists Methods.
    // -------------------------------------------
    
    func fetchArticlesFromServer() {
        newsviewmodel.fetchNewsOperation()
    }
    
    func fetchArticlesFromLocalStorage() {
        newsviewmodel.loadArticlesFromRealmSwiftOperaiton()
    }
    
    // -------------------------------------------
}
