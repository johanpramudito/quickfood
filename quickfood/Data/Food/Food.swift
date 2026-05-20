//
//  Food.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 20/05/26.
//

import SwiftUI

struct Food: Identifiable, Codable, Hashable {
    let id: UUID

    var name: String
    var description: String?
    
    var texture: Set<Texture>
    var taste: Set<Taste>

    var allergens: Set<Allergen>

    var imageName: String?


    var isActive: Bool
}

