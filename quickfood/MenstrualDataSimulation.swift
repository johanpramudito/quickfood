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
            
            ForEach(healthViewModel.dataPoints) { dataPoint in
                Text(dataPoint.startDate.formatted(date: .abbreviated, time: .omitted))
                
                Text("\(dataPoint.flow)")
            }
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
        guard let latestDataPoint = healthViewModel.dataPoints.first,
              latestDataPoint.isStartCycle else {
            return
        }

        listCycle = makeCycleData(duration: 27, startDate: latestDataPoint.startDate)
    }
}

#Preview {
    MenstrualDataSimulation()
}
