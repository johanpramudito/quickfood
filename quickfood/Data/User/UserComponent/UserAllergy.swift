//
//  UserAllergy.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 20/05/26.
//

enum UserAllergy: String, Codable, Hashable, CaseIterable {
    case chicken
    case beef
    case peanuts
    case treeNuts
    case seafood
    case shellfish
    case egg
    case milk
    case soy
    case wheat
    case sesame
    case gluten
    case offal

    var title: String {
        switch self {
        case .chicken: "Chicken"
        case .beef: "Beef"
        case .peanuts: "Peanuts"
        case .treeNuts: "Tree Nuts"
        case .seafood: "Seafood"
        case .shellfish: "Shellfish"
        case .egg: "Egg"
        case .milk: "Milk"
        case .soy: "Soy"
        case .wheat: "Wheat"
        case .sesame: "Sesame"
        case .gluten: "Gluten"
        case .offal: "Offal"
        }
    }

    var icon: String {
        switch self {
        case .chicken: "🍗"
        case .beef: "🥩"
        case .peanuts: "🥜"
        case .treeNuts: "🌰"
        case .seafood: "🐟"
        case .shellfish: "🦐"
        case .egg: "🥚"
        case .milk: "🥛"
        case .soy: "🫘"
        case .wheat: "🌾"
        case .sesame: "⚪"
        case .gluten: "🍞"
        case .offal: "🧠"
        }
    }
}

