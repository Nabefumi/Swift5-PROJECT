//
//  MatchCellViewModel.swift
//  MatchingApp
//
//  Created by Takafumi Watanabe on 2022-02-16.
//

import Foundation

struct MatchCellViewModel {
    
    let nameText: String
    let profileImageUrl: URL?
    let uid: String
    
    init(match: Match) {
        nameText = match.name
        profileImageUrl = URL(string: match.profileImageUrl)
        uid = match.uid
    }
    
}
