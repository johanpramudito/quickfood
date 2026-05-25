//
//  Food.swift
//  quickfood/Users/muhammadnajmirahmani/quickfood/quickfood/Data/Food/Food.swift
//
//  Created by Bintang Marsyuma Rakhasunu on 20/05/26.
//

import SwiftData


@Model
final class Food {
    var name: String
    var category: String
    var tags: [String]
    var nutrition: [String]
    var cyclePhase: String
    var notes: String
    var image: String  // ← add this

    init(name: String, category: String, tags: [String], nutrition: [String], cyclePhase: String, notes: String, image: String) {
        self.name = name
        self.category = category
        self.tags = tags
        self.nutrition = nutrition
        self.cyclePhase = cyclePhase
        self.notes = notes
        self.image = image  // ← add this
    }
}
