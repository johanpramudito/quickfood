//
//  HomeViewModel.swift
//  quickfood
//
//  Created by Muhammad Ridwan Novriansyah on 22/05/26.
//

import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var status = "Not checked yet"
    @Published private(set) var todayCycleDay: CycleDay?

    private let healthModel: HealthCheckViewModel
    private var hasCheckedHealthData = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.healthModel = HealthCheckViewModel()
        bindHealthModel()
    }

    init(healthModel: HealthCheckViewModel) {
        self.healthModel = healthModel
        bindHealthModel()
    }

    func loadHealthDataIfNeeded() {
        guard !hasCheckedHealthData else { return }

        hasCheckedHealthData = true
        healthModel.checkHealthData()
    }

    func displayName(from userName: String) -> String {
        userName.isEmpty ? "there" : userName
    }

    func selectedAllergies(from rawValues: String) -> [UserAllergy] {
        let selectedRawValues = Set(
            rawValues
                .split(separator: ",")
                .map(String.init)
        )

        return UserAllergy.allCases.filter { selectedRawValues.contains($0.rawValue) }
    }

    func greeting(for date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)

        switch hour {
        case 5..<12:
            return "Morning"
        case 12..<17:
            return "Afternoon"
        case 17..<21:
            return "Evening"
        default:
            return "Night"
        }
    }

    private func bindHealthModel() {
        healthModel.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.status = status
            }
            .store(in: &cancellables)

        healthModel.$dataPoints
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dataPoints in
                guard let startDate = dataPoints.first?.startDate else {
                    self?.todayCycleDay = estimatedCurrentCycleDay()
                    return
                }

                self?.todayCycleDay = currentCycleDay(from: startDate)
            }
            .store(in: &cancellables)
    }
}
