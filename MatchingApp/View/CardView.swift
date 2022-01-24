//
//  CardView.swift
//  MatchingApp
//
//  Created by Takafumi Watanabe on 2022-01-24.
//

import UIKit

class CardView: UIView {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
