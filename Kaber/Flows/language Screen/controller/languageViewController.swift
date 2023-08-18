//
//  languageViewController.swift
//  Kaber
//
//  Created by Mohamed Ali on 17/08/2023.
//

import UIKit
import RxSwift

class languageViewController: UIViewController {

    // MARK: TODO: IBOutlets:
    @IBOutlet weak var arabicRadioButton:UIButton!
    @IBOutlet weak var englishRadioButton:UIButton!
    
    @IBOutlet weak var arabicView:UIView!
    @IBOutlet weak var englishView:UIView!

    @IBOutlet weak var nextButton:UIButton!
    
    // MARK: TODO: variables here:
    var pereferedLanguage: String?
    var choocelanguageviewmodel: chooceLanguageViewModel!
    var UIComponets: [chooceLanguageModel]!
    let disposebag = DisposeBag()
    let viewBorderColorName  = "ButtonColor"
    let otherBorderColorName = "BorderColor"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        SetUIComponts()
        subscribeToChangeLanguageBehaviour()
        SubscribeToPickedPlace()
        SubscribeToNextButtonAction()
    }
    
    func SetUIComponts() {
        UIComponets = [chooceLanguageModel(button: arabicRadioButton, view: arabicView),
                       chooceLanguageModel(button: englishRadioButton, view: englishView),
                      ]
    }
    
    func subscribeToChangeLanguageBehaviour() {
        choocelanguageviewmodel.changeLanguageBehaviour.subscribe(onNext: { isChanged in
            
            if isChanged {
                
                // MARK: - solution One show alert make app restart:
//                let alert = UIAlertController(title: myStrings.attension, message: myStrings.langMess, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: myStrings.restart, style: .default,handler: { _ in
//                    exit(0)
//                }))
//
//                present(alert, animated: true)
                
                // MARK: - restart app within app.
                AppCoordinator.shared.restart()
            }
            
            
        }).disposed(by: disposebag)
    }
    
    func SubscribeToPickedPlace() {
        choocelanguageviewmodel.pickedPlaceBehaviour.asObservable().subscribe(onNext: { [unowned self]  msg in
            if msg != .none  {
                print("picked language: \(msg)")
                nextButton.isEnabled = true
                nextButton.layer.opacity = 1
            }
            else {
                nextButton.isEnabled = false
                nextButton.layer.opacity = 0.5
            }
        }).disposed(by: disposebag)
    }
    
    @IBAction func radioButtonSelected(_ sender: UIButton) {
        choocelanguageviewmodel.choocePlace(buttonId: sender.tag)
        updateUI(selectedUI: UIComponets![sender.tag - 1])
    }
    
    private func updateUI(selectedUI: chooceLanguageModel) {
        UIComponets.forEach { model in
            if model.button == selectedUI.button {
                model.button.isSelected = true
                model.view.updateBorderColor(colorName: images.colorSelectedBorder.name)
            }
            else {
                model.button.isSelected = false
                model.view.updateBorderColor(colorName: images.borderCell.name)
            }
        }
    }
    
    
    func SubscribeToNextButtonAction() {
        nextButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] _ in
            choocelanguageviewmodel.goToNewsScreenOperation()
        }).disposed(by: disposebag)
    }

}
