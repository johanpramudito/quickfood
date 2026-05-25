//
//  UserProfile.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 20/05/26.
//

import SwiftUI

struct UserProfile: Identifiable, Codable {
    let id: Int
    
    var displayName: String
    
//    var allergies: [UserAllergy]
    
}

#Preview {
    let profile = UserProfile(id: 1, displayName: "Preview User")
    Text(profile.displayName)
}
