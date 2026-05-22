import Foundation

enum CyclePhase: String {
    case menstruationPhase
    case follicularPhase
    case ovulationPhase
    case lutealPhase
}

struct CycleDay {
    let date: Date
    let phases: [CyclePhase]
    let day: Int
}

let cycleLength = 27

func phases(for day: Int) -> [CyclePhase] {
    var phases: [CyclePhase] = []

    if (1...5).contains(day) {
        phases.append(.menstruationPhase)
    }

    if (1...13).contains(day) {
        phases.append(.follicularPhase)
    }

    if day == 14 {
        phases.append(.ovulationPhase)
    }

    if (15...27).contains(day) {
        phases.append(.lutealPhase)
    }

    return phases
}

func currentCycleDay(
    from startDate: Date,
    today: Date = Date(),
    cycleLength: Int = 27
) -> CycleDay? {
    let calendar = Calendar.current

    let start = calendar.startOfDay(for: startDate)
    let current = calendar.startOfDay(for: today)

    let daysPassed = calendar.dateComponents([.day], from: start, to: current).day ?? 0

    guard daysPassed >= 0 else {
        return nil
    }

    let day = (daysPassed % cycleLength) + 1

    return CycleDay(
        date: current,
        phases: phases(for: day),
        day: day
    )
}

func estimatedCurrentCycleDay(today: Date = Date(), cycleLength: Int = 27) -> CycleDay {
    let calendar = Calendar.current
    let current = calendar.startOfDay(for: today)
    let dayOfMonth = calendar.component(.day, from: current)
    let day = ((dayOfMonth - 1) % cycleLength) + 1

    return CycleDay(
        date: current,
        phases: phases(for: day),
        day: day
    )
}
