//
//  refreshController.swift
//  Kaber
//
//  Created by Mohamed Ali on 18/08/2023.
//

import UIKit

class LoadMoreFooterView: UIView {
    let loadMoreButton = LoadingButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadMoreButton.loading = true
        loadMoreButton.indicatorAlignmentCenter = .Center
        loadMoreButton.indicatorColor = .gray
        loadMoreButton.setTitle("", for: .normal)
        loadMoreButton.isEnabled = false
        
        addSubview(loadMoreButton)
        
        // Add layout constraints to position the button within the view
        // Adjust constraints as needed based on your UI design
        loadMoreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadMoreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
