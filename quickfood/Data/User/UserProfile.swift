//
//  UserProfile.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 20/05/26.
//

import SwiftUI

struct UserProfile: Identifiable, Codable {
    let id: UUID
    
    var displayName: String
    
    var allergies: [UserAllergy]
    
}
