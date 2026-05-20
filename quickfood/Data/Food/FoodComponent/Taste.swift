//
//  Taste.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 20/05/26.
//

enum Taste: String, Codable {
    case sweet, salty, sour, bitter, spicy, savory, umami
    
    var id: String { rawValue }
}
