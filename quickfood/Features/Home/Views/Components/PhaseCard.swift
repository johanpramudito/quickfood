//
//  PhaseCard.swift
//  quickfood
//
//  Created by Muhammad Ridwan Novriansyah on 22/05/26.
//

import SwiftUI

struct PhaseCard: View {
    let cycleDay: CycleDay?

    init(cycleDay: CycleDay? = nil) {
        self.cycleDay = cycleDay
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Current Phase:")
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
                .font(.system(.callout, design: .default, weight: .bold))
                .foregroundColor(.white)

            HStack {
                Text(phaseIcon)
                    .font(.system(size: 50))
                    .accessibilityLabel(phaseTitle + " icon")
                    .accessibilityHidden(false)

                VStack(alignment: .leading) {
                    Text(phaseTitle)
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .foregroundColor(.white)

                    Text(cycleDayText)
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                    
                }
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            }
            
            HStack{
                Text(captionPhase)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            .font(.subheadline)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(8)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .background(Color.primaryYellow)
        .cornerRadius(20)
        .padding(20)
        
    }

    private var phase: CyclePhase? {
        cycleDay?.phases.first
    }

    private var phaseTitle: String {
        switch phase {
        case .menstruationPhase:
            return "Menstrual Phase"
        case .follicularPhase:
            return "Follicular Phase"
        case .ovulationPhase:
            return "Ovulation Phase"
        case .lutealPhase:
            return "Luteal Phase"
        case nil:
            return "No current cycle info"
        }
    }

    private var phaseIcon: String {
        switch phase {
        case .menstruationPhase:
            return "🩸"
        case .follicularPhase:
            return "🌱"
        case .ovulationPhase:
            return "🥚"
        case .lutealPhase:
            return "🌙"
        case nil:
            return "–"
        }
    }
    
    private var captionPhase: String {
        switch phase {
        case .menstruationPhase:
            return "Your body needs extra rest and nutrient-dense, warming foods to replenish energy and iron levels."
        case .follicularPhase:
            return "Your body needs extra rest and nutrient-dense, warming foods to replenish energy and iron levels."
        case .ovulationPhase:
            return "Your body needs extra rest and nutrient-dense, warming foods to replenish energy and iron levels."
        case .lutealPhase:
            return "Your body needs extra rest and nutrient-dense, warming foods to replenish energy and iron levels."
        case nil:
            return "–"
        }
    }

    private var cycleDayText: String {
        guard let cycleDay else {
            return "Load Health data to check your cycle"
        }

        return "Day \(cycleDay.day) of your cycle"
    }
    
}

#Preview {
    PhaseCard(
        cycleDay: CycleDay(
            date: .now,
            phases: [.menstruationPhase],
            day: 3
        )
    )
}
