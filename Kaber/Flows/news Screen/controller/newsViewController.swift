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
    let paddingValue: CGFloat = 38
    let newsCellStr = "newsCell"
    var footerView: LoadMoreFooterView!
    
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
        subscribeToPagingBehaviour()
        
        
        // Action button methods.
        
        
        // Assits method.
    }
    
    // MARK:  - Methods that handle UI Element in UI.
    // -------------------------------------------
    
    func configureUI() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = myStrings.news
        
        self.changeFontForNavigationController()
        searchTextField.setLeftPaddingPoints(paddingValue)
        searchTextField.setRightPaddingPoints(paddingValue)
        searchTextField.attributedPlaceholder =
        NSAttributedString(string: myStrings.search, attributes: [NSAttributedString.Key.foregroundColor: images.bodyTextGrayScale.color])
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            searchTextField.textAlignment = .left
        }
        else {
            searchTextField.textAlignment = .right
        }
        
        
        // Create and set the custom refresh view as the footer
        footerView = LoadMoreFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        tableView.tableFooterView = footerView
        tableView.rx.setDelegate(self).disposed(by: disposebag)
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
       
        NetworkManagerReachability.sharedInstance.connectionBehaviour.asObservable().subscribe(onNext: { [weak self] isConnected in
            guard let self = self else { return }
            
            guard let isConnected = isConnected else { return }
            
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
                dismissLoading()
            }
        }).disposed(by: disposebag)
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
    
    func subscribeToPagingBehaviour() {
        newsviewmodel.pagaignLoadingBehaviour.subscribe(onNext: { [unowned self] isloading in
            
            if isloading {
                  tableView.tableFooterView = footerView
//                bottomRefreshView.beginRefreshing()
            }
            else {
                tableView.tableFooterView = nil
//                bottomRefreshView.endRefreshing()
            }
        }).disposed(by: disposebag)
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

extension newsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 200 // Adjust this value as needed
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let distanceFromBottom = contentHeight - contentOffsetY - scrollView.bounds.height
            
        if distanceFromBottom < threshold && !newsviewmodel.pagaignLoadingBehaviour.value {
            newsviewmodel.fetchNextPageOperation()
        }
    }
}
