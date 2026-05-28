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
        .background(
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.635, blue: 0.145),
                    Color(red: 0.776, green: 0.447, blue: 0.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
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
            return "Your body may need more rest, iron-rich foods, warm meals, and gentle hydration to help replenish energy during your period."

        case .follicularPhase:
            return "Your energy may start to rise, so fresh, protein-rich, and fiber-filled foods can help support recovery and hormone balance."

        case .ovulationPhase:
            return "Your body may benefit from antioxidant-rich foods, lean protein, and plenty of hydration to support peak energy and overall balance."

        case .lutealPhase:
            return "Your body may need steady meals, complex carbs, magnesium-rich foods, and calming nutrients to help manage cravings and mood changes."

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
