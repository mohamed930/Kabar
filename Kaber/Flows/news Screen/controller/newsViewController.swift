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
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var connectionBannerView:UIView!
    
    @IBOutlet weak var mesageLabel: UILabel!
    @IBOutlet weak var placeHolderView: UIView!
    @IBOutlet weak var suggestionView: UIView!
    @IBOutlet weak var suggestionTableView: UITableView!
       
    // MARK: - variables Here:
    var newsviewmodel: newsViewModel!
    let disposebag = DisposeBag()
    let paddingValue: CGFloat = 38
    let newsCellStr   = "newsCell"
    let searchCellStr = "searchCell"
    var footerView: LoadMoreFooterView!
    var tag: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI methods.
        configureUI()
        regesterTableView()
        regesterSearchTableView()
                
        // Bind methods.
        bindNewsBehaviourToTableView()
        bindToSearchTextField()
        bindToSearchTableView()
        
        
        // Subscribe methods.
        subscribeToBeginEditInSearchTextField()
        subscribeToPlaceHolderBehaviour()
        subscribeToHitSearchButton()
        subscribeToHitSearchApi()
        subscribeToSelectSuggestedArticleTableView()
        
        subscribeToInterConnectionRestore()
        
        subscribeToIsLoadingBehaviour()
        subscribeToSelectArticleTableView()
        subscribeToPagingBehaviour()
        
        
        // Action button methods.
        subscribeToCancelButtonAction()
        
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
    
    func regesterSearchTableView() {
        suggestionTableView.register(UINib(nibName: searchCellStr, bundle: nil), forCellReuseIdentifier: searchCellStr)
        
        // Create and set the custom refresh view as the footer
        footerView = LoadMoreFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        suggestionTableView.tableFooterView = footerView
        suggestionTableView.rx.setDelegate(self).disposed(by: disposebag)
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
    
    func bindToSearchTextField() {
        searchTextField.rx.text.orEmpty.bind(to: newsviewmodel.searchTextFieldBehaviourRelay).disposed(by: disposebag)
    }
    
    func bindToSearchTableView() {
        newsviewmodel.SearchednewsObervable.bind(to: suggestionTableView.rx.items(cellIdentifier: searchCellStr, cellType: searchCell.self)) { row, branch, cell in
            
            cell.configureCell(branch)
            
        }.disposed(by: disposebag)
    }
    
    // -------------------------------------------
    
    // MARK: -  Methods that handle the Subscribe of variables in ViewModel Class.
    // -------------------------------------------
    
    func subscribeToBeginEditInSearchTextField() {
        newsviewmodel.searchTextFieldBehaviourRelay.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            
            cancelButton.isHidden = text.isEmpty
            suggestionView.isHidden = text.isEmpty
            
            if text.isEmpty {
                newsviewmodel.clearSearchResult()
                mesageLabel.text = myStrings.keywords
            }
            
        }).disposed(by: disposebag)
    }
    
    func subscribeToPlaceHolderBehaviour() {
        newsviewmodel.placeHolderBehaviourRelay.subscribe(onNext: { [unowned self] isShowed in
            placeHolderView.isHidden = !isShowed
        }).disposed(by: disposebag)
    }
    
    func subscribeToHitSearchButton() {
        searchTextField.rx.controlEvent([.editingDidEnd,.editingDidEndOnExit]).subscribe(onNext: { [unowned self] _ in
            newsviewmodel.searchArticleOperation()
        }).disposed(by: disposebag)
    }
    
    func subscribeToHitSearchApi() {
        newsviewmodel.filteredObservable.subscribe(onNext: { [unowned self] isValid in
            if isValid {
                newsviewmodel.searchArticleOperation()
            }
        }).disposed(by: disposebag)
    }
    
    func subscribeToSelectSuggestedArticleTableView() {
        Observable.zip(suggestionTableView.rx.itemSelected, suggestionTableView.rx.modelSelected(ArticleModel.self).throttle(.milliseconds(500), scheduler: MainScheduler.instance))
           .bind { [weak self] selectedIndex, branch in

           guard let self = self else { return }
               
           newsviewmodel.moveToNewsDetailsOperation(article: branch)
               
       }.disposed(by: disposebag)
    }
    
    func subscribeToInterConnectionRestore() {
       
        NetworkManagerReachability.sharedInstance.connectionBehaviour.asObservable().subscribe(onNext: { [weak self] isConnected in
            guard let self = self else { return }
            
            guard let isConnected = isConnected else { return }
            
            if isConnected == true {
                // Connection is available
                print("Connected to the internet")
                connectionBannerView.isHidden = true
                fetchArticlesFromServer()
                searchTextField.isEnabled = true

            } else {
                // No connection
                print("No internet connection")
                connectionBannerView.isHidden = false
                fetchArticlesFromLocalStorage()
                dismissLoading()
                searchTextField.isEnabled = false
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
                if tag == 1 {
                    tableView.tableFooterView = footerView
                }
                else {
                    suggestionTableView.tableFooterView = footerView
                }
                  
            }
            else {
                if tag == 1 {
                    tableView.tableFooterView = nil
                }
                else {
                    suggestionTableView.tableFooterView = nil
                }
                
            }
        }).disposed(by: disposebag)
    }
    
    // -------------------------------------------
    
    // MARK: - Methods that handle Button Actions in the UI.
    // -------------------------------------------
    
    func subscribeToCancelButtonAction() {
        cancelButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] _ in
            
            searchTextField.text = ""
            suggestionView.isHidden = true
            cancelButton.isHidden = true
        }).disposed(by: disposebag)
    }
    
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
        if scrollView.tag == 1 {
            tag = 1
            let threshold: CGFloat = 200 // Adjust this value as needed
            let contentOffsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let distanceFromBottom = contentHeight - contentOffsetY - scrollView.bounds.height
                
            if distanceFromBottom < threshold && !newsviewmodel.pagaignLoadingBehaviour.value {
                newsviewmodel.fetchNextPageOperation()
            }
        }
        else {
            tag = 2
            let threshold: CGFloat = 200 // Adjust this value as needed
            let contentOffsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let distanceFromBottom = contentHeight - contentOffsetY - scrollView.bounds.height
                
            if distanceFromBottom < threshold && !newsviewmodel.pagaignLoadingBehaviour.value {
                newsviewmodel.searchArticleOperation()
            }
        }
        
    }
}
