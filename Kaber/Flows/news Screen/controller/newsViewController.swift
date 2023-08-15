//
//  newsViewController.swift
//  Kaber
//
//  Created by Mohamed Ali on 15/08/2023.
//

import UIKit
import RxSwift

class newsViewController: UIViewController {

    // MARK:  - IBOutlets Here:
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
       
       
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
        
        
        // Action button methods.
        
        
        // Assits method.
        fetchArticlesFromServer()
    }
    
    // MARK:  - Methods that handle UI Element in UI.
    // -------------------------------------------
    
    func configureUI() {
        navigationItem.title = myStrings.news
        self.changeFontForNavigationController()
        searchTextField.setLeftPaddingPoints(paddingValue)
        searchTextField.setRightPaddingPoints(paddingValue)
        searchTextField.placeholder = myStrings.search
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
                
                newsviewmodel.openArticleOperaion()
            }).disposed(by: cell.disposebag)
            
        }.disposed(by: disposebag)
    }
    
    // -------------------------------------------
    
    // MARK: -  Methods that handle the Subscribe of variables in ViewModel Class.
    // -------------------------------------------
    
    // -------------------------------------------
    
    // MARK: - Methods that handle Button Actions in the UI.
    // -------------------------------------------
    
    // -------------------------------------------
    
    // MARK: - Assists Methods.
    // -------------------------------------------
    
    func fetchArticlesFromServer() {
        newsviewmodel.fetchNewsOperation()
    }
    
    // -------------------------------------------
}
