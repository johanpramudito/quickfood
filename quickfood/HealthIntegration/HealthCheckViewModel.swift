//
//  HealthCheckViewModel.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 21/05/26.
//

import Foundation
import HealthKit
import Combine

final class HealthCheckViewModel: ObservableObject {
    @Published var status = "Not checked yet"
    @Published var dataPoints: [MenstrualFlowDataPoint] = []

    private let healthStore = HKHealthStore()

    func checkHealthData(completion: @escaping () -> Void = {}) {
        guard HKHealthStore.isHealthDataAvailable() else {
            status = "HealthKit is not available on this device."
            completion()
            return
        }

        guard let menstrualFlowType = HKObjectType.categoryType(
            forIdentifier: .menstrualFlow
        ) else {
            status = "Menstrual flow type is not available."
            completion()
            return
        }

        status = "Requesting permission..."

        healthStore.requestAuthorization(
            toShare: [],
            read: [menstrualFlowType]
        ) { success, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.status = "Authorization error: \(error.localizedDescription)"
                    completion()
                }
                return
            }

            guard success else {
                DispatchQueue.main.async {
                    self.status = "Permission not granted."
                    completion()
                }
                return
            }

            self.fetchMenstrualFlowSamples(type: menstrualFlowType, completion: completion)
        }
    }

    private func fetchMenstrualFlowSamples(type: HKCategoryType, completion: @escaping () -> Void) {
        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        )

        let query = HKSampleQuery(
            sampleType: type,
            predicate: nil,
            limit: 100,
            sortDescriptors: [sort]
        ) { _, samples, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.status = "Query error: \(error.localizedDescription)"
                    completion()
                    return
                }

                let menstrualSamples = samples as? [HKCategorySample] ?? []
                print(menstrualSamples)
                
                self.dataPoints = menstrualSamples.map { sample in
                    MenstrualFlowDataPoint(
                        startDate: sample.startDate,
                        flow: self.flowDescription(sample.value),
                        isStartCycle: sample.metadata?[HKMetadataKeyMenstrualCycleStart] as? Bool ?? false,
                        source: sample.sourceRevision.source.name
                    )
                }

                self.status = "Found \(self.dataPoints.count) menstrual flow records."
                completion()
            }
        }

        healthStore.execute(query)
    }

    private func flowDescription(_ value: Int) -> String {
        guard let flow = HKCategoryValueVaginalBleeding(rawValue: value) else {
            return "Unknown"
        }

        switch flow {
        case .unspecified:
            return "Unspecified flow"
        case .light:
            return "Light flow"
        case .medium:
            return "Medium flow"
        case .heavy:
            return "Heavy flow"
        case .none:
            return "No flow"
        @unknown default:
            return "Unknown"
        }
    }
}
