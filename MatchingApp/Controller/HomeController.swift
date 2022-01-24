//
//  HomeController.swift
//  MatchingApp
//
//  Created by Takafumi Watanabe on 2022-01-11.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let topStack = HomeNavigationStackView()
    private let b0ttomStack = BottomControlsStackView()
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 5
        return view
        
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews:  [topStack, deckView, b0ttomStack])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top:0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
    }
}
