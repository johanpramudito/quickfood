//
//  Food.swift
//  quickfood/Users/muhammadnajmirahmani/quickfood/quickfood/Data/Food/Food.swift
//
//  Created by Bintang Marsyuma Rakhasunu on 20/05/26.
//

import SwiftUI

struct Food: Identifiable, Codable, Hashable {
    let id: UUID

    var name: String
    var description: String?
    
    var tag: Set<foodTag>

    var imageName: String?


    var isActive: Bool
}

