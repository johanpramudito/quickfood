//
//  ContentView.swift
//  quickfood
//
//  Created by Johan on 20/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State var hasCheckedHealthData: Bool = false
    
    @StateObject var healthModel = HealthCheckViewModel()
    
    @State private var firstDay: Date?
    @State private var todayCycleDay: CycleDay?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if let firstDay {
                    Text("First day: \(firstDay.formatted(date: .abbreviated, time: .omitted))")
                }

                if let todayCycleDay {
                    Text("Day-\(todayCycleDay.day)")
                        .font(.title)

                    Text(todayCycleDay.phases.map { $0.rawValue }.joined(separator: ", "))
                        .font(.headline)
                } else {
                    Text("No current cycle info")
                        .foregroundStyle(.secondary)
                }

                Text(healthModel.status)
                    .multilineTextAlignment(.center)

            }
            .padding()
            .navigationTitle("Health Data")
            .task {
                guard !hasCheckedHealthData else { return }
                hasCheckedHealthData = true
                healthModel.checkHealthData()
            }
            .onChange(of: healthModel.dataPoints.first?.startDate) { _, startDate in
                guard let startDate else { return }

                firstDay = startDate
                todayCycleDay = currentCycleDay(from: startDate)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
        let healthData = HealthCheckViewModel().dataPoints[0]
        print("Health data: \(healthData)")
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

func checkPhase(){
    
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
