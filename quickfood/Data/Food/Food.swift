//
//  Food.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 20/05/26.
//

import SwiftData


@Model
final class Food {
    var name: String
    var category: String
    var tags: [String]
    var cyclePhase: String
    var notes: String

    init(name: String, category: String, tags: [String],cyclePhase: String, notes: String) {
        self.name = name
        self.category = category
        self.tags = tags
        self.cyclePhase = cyclePhase
        self.notes = notes
    }
}
