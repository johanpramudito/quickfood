//
//  MenstrualFlowDataPoint.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 21/05/26.
//

import SwiftUI
import HealthKit

struct MenstrualFlowDataPoint: Identifiable {
    let id = UUID()
    let startDate: Date
    let flow: String
    let isStartCycle: Bool
    let source: String
}

struct HealthCheckView: View {
    @State private var viewModel = HealthCheckViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text(viewModel.status)
                    .multilineTextAlignment(.center)

                Button("Load Menstrual Data") {
                    viewModel.checkHealthData()
                }
                .buttonStyle(.borderedProminent)

                List(viewModel.dataPoints) { point in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(point.flow)
                            .font(.headline)

                        Text("Start: \(point.startDate.formatted(date: .abbreviated, time: .shortened))")
                        Text("Source: \(point.source)")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .navigationTitle("Health Data")
        }
    }
}
