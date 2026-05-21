//
//  MenstrualPhase.swift
//  quickfood
//
//  Created by Muhammad Najmi Rahmani  on 21/05/26.
//

import Foundation
import SwiftUI

enum MenstrualPhase: String, CaseIterable {
    case mens = "Menstruation"
    case ovulation = "Ovulation"
    case follicular = "Follicular"
    case luteal = "Luteal"
}

var duration: Int = 27
var dateNow: Date = Date()
var listCycle: [cycleData] = makeCycleData(duration: duration, startDate: dateNow)

struct cycleData {
    var date: Date
    var phase: MenstrualPhase
    var day: Int
}

func makeCycleData(duration: Int, startDate: Date) -> [cycleData] {
    var cycles: [cycleData] = []
    var currentDate = startDate
    var day = 1

    for _ in 0..<duration {
        currentDate.addTimeInterval(86400)
        day += 1

        let phase = phase(for: day)
        let cycle = cycleData(date: currentDate, phase: phase, day: day)
        cycles.append(cycle)
    }

    return cycles
}

func phase(for cycleDay: Int) -> MenstrualPhase {
    switch cycleDay {
    case 1...5:
        return .mens
    case 6...13:
        return .follicular
    case 14:
        return .ovulation
    case 15...27:
        return .luteal
    default:
        return .mens
    }
}
