//
//  MenstrualPhase.swift
//  quickfood
//
//  Created by Muhammad Najmi Rahmani  on 21/05/26.
//

import Foundation

struct MenstrualPhase {
    let duration: Int

    var cycleDays: [Int] {
        Array(1...duration)
    }

    init(duration: Int = 27) {
        self.duration = duration
    }
}
