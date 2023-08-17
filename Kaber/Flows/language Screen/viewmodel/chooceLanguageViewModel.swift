//
//  chooceLanguageViewModel.swift
//  Kaber
//
//  Created by Mohamed Ali on 17/08/2023.
//

import Foundation
import RxSwift
import RxRelay
import MOLH

class chooceLanguageViewModel {
    
    let pickedPlaceBehaviour = BehaviorRelay<langugae>(value: .none)
    let arrOfUIBehaviour = BehaviorRelay<[chooceLanguageModel]>(value: [])
    let changeLanguageBehaviour = BehaviorRelay<Bool>(value: false)
    
    
    var coordinator: chooceLanguageCoordinator!
    
    enum langugae: String {
        case none
        case arabic
        case english
    }
    
    func choocePlace(buttonId: Int) {
        if buttonId == 1 {
            pickedPlaceBehaviour.accept(.arabic)
        }
        else if buttonId == 2 {
            pickedPlaceBehaviour.accept(.english)
        }
    }
    
    func goToNewsScreenOperation() {
        saveUserStatus()
        let localStorage: LocalStorage = LocalStorage()
        
        switch pickedPlaceBehaviour.value {
            
        case .none:
            break
        case .arabic:
            
            if MOLHLanguage.currentAppleLanguage() == "en" {
                localStorage.write(key: LocalStorageKeys.AppleLanguages, value: ["ar"])
                changeLanguageBehaviour.accept(true)
            }
            else {
                coordinator.goToNewsScreen()
            }
            
        case .english:
            if MOLHLanguage.currentAppleLanguage() == "ar" {
                localStorage.write(key: LocalStorageKeys.AppleLanguages, value: ["en"])
                changeLanguageBehaviour.accept(true)
            }
            else {
                coordinator.goToNewsScreen()
            }
        }
        
//        coordinator.goToNewsScreen()
    }
    
    private func saveUserStatus() {
        let local: LocalStorage = LocalStorage()
        local.write(key: LocalStorageKeys.firstTime, value: true)
    }
}
