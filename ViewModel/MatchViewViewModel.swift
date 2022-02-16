//
//  MatchViewViewModel.swift
//  MatchingApp
//
//  Created by Takafumi Watanabe on 2022-02-16.
//

import Foundation

struct MatchViewViewModel {
    private let currentUser: User
    let matchedUser: User
    
    let matchLabelText: String
    
    var currentUserImageURL: URL?
    var matchedUserImageURL: URL?
    
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        matchLabelText = "You and \(matchedUser.name) have like each other!"
        
        guard let imageUrlString = currentUser.imageURLs.first else { return }
        guard let matchedUserImageUrlString = matchedUser.imageURLs.first else { return }

        currentUserImageURL = URL(string: imageUrlString)
        matchedUserImageURL = URL(string: matchedUserImageUrlString)
    }
}
