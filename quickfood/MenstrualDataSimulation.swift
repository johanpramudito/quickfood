//
//  MenstrualDataSimulation.swift
//  quickfood
//
//  Created by Muhammad Najmi Rahmani  on 21/05/26.
//

import SwiftUI

struct MenstrualDataSimulation: View {
    @StateObject private var healthViewModel = HealthCheckViewModel()
    @State private var listCycle: [cycleData] = []
    @State private var todayDate: Date = Date()
    var body: some View {
        VStack(spacing: 16) {
            Text("List of Menstrual Cycle Data")
                .font(.title)
                .fontWeight(.bold)

            Button {
                loadCycleData()
            } label: {
                Text("Generate Data")
            }
            .buttonStyle(.borderedProminent)

            let todayPhase = getPhase(todayDate: todayDate, listCycle: listCycle)
            let todayDay = getDay(todayDate: todayDate, listCycle: listCycle)

            Text("Hari ke : \(todayDay) dalam siklus")
            Text("Today: \(todayPhase.rawValue)")
        }
        .onAppear {
            loadCycleData()
        }
    }

    private func loadCycleData() {
        healthViewModel.checkHealthData {
            updateCycleData()
        }
    }

    private func updateCycleData() {
        guard let latestDataPoint = healthViewModel.dataPoints.last,
              latestDataPoint.isStartCycle else {
            return
        }

        listCycle = makeCycleData(duration: 27, startDate: latestDataPoint.startDate)
    }
}

#Preview {
    MenstrualDataSimulation()
}
