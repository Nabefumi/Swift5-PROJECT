//
//  HomeController.swift
//  MatchingApp
//
//  Created by Takafumi Watanabe on 2022-01-11.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User?
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private var viewModels = [CardViewModel]() {
        didSet { configureCards() }
    }
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 5
        return view
        
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureUI()
        fetchUsers()
        fetchUser()
//        logout()

    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func fetchUsers() {
        Service.fetchUsers { users in
            self.viewModels = users.map({ CardViewModel(user: $0) })
                
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
            print("DEBUG: User is logged in...")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Failed to sign out...")
        }
    }
    
    // MARK: - Helpers
    
    func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
//            cardViews.append(cardView)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.map({ ($0 as? CardView)! })
        topCardView = cardViews.last
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        topStack.delegate = self
        bottomStack.delegate = self
        
        let stack = UIStackView(arrangedSubviews:  [topStack, deckView, bottomStack])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top:0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func performSwipeanimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700 : -700
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.topCardView?.frame = CGRect(x: translation, y: 0,
                                             width: (self.topCardView?.frame.width)!,
                                             height: (self.topCardView?.frame.height)!)
        }) { _ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
    }
}

// MARK: - HomeNavigationStackViewDelegate

extension HomeController: HomeNavigationStackViewDelegate {
    func showSettings() {
        guard let user = self.user else { return }
        let controller = SettingsController(user: user)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showMessages() {
        print("DEBUG: Show messages from home controller")
    }
}

// MARK: - SettingsControllerDelegate

extension HomeController: SettingsControllerDelegate {
    func settingsControllerWantsToLogout(_ controller: SettingsController) {
        controller.dismiss(animated: true, completion: nil)
        logout()
    }
    
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
    }
}

// MARK: - CardViewDelegate

extension HomeController: CardViewDelegate {
    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        let controller = ProfileController(user: user)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
                                           
    }
}

extension HomeController: BottomControlsStackViewDelegate {
    func handleLike() {
        guard let topCard = topCardView else { return }
        
        performSwipeanimation(shouldLike: true)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: true)
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        
        performSwipeanimation(shouldLike: false)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: false)
    }
    
    func handleRefresh() {
        print("DEBUG: Handle refreshing here...")
    }
    
    
}
