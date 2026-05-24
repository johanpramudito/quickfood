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
    
    @Query private var foods: [Food]
    
    @State var hasCheckedHealthData: Bool = false
    
    @StateObject var healthModel = HealthCheckViewModel()
    
    @State private var firstDay: Date?
    @State private var todayCycleDay: CycleDay?
    
    var recommendedFoods: [Food] {
        guard let phase = todayCycleDay?.phases.first?.rawValue else {
            return []
        }
        
        return foods.filter { $0.cyclePhase == phase }
    }
    
    
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
                
                List(recommendedFoods) { food in
                    VStack(alignment: .leading) {
                        Text(food.name)
                            .font(.headline)
                        
                        Text(food.category)
                            .foregroundStyle(.secondary)
                        
                        Text(food.notes)
                            .font(.caption)
                        
                        ForEach(food.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                        }
                    }
                }
                
            }
            .padding()
            .navigationTitle("Health Data")
            .task {
                seedFoodsIfNeeded(modelContext: modelContext)
                
                guard !hasCheckedHealthData else { return }
                hasCheckedHealthData = true
                healthModel.checkHealthData()
                print(recommendedFoods)
            }
            .onChange(of: healthModel.dataPoints.first?.startDate) { _, startDate in
                guard let startDate else { return }
                
                firstDay = startDate
                todayCycleDay = currentCycleDay(from: startDate)
            }
            
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Food.self, inMemory: true)
}
