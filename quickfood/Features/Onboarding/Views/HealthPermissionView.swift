//
//  HealthPermissionView.swift
//  quickfood
//
//  Created by Johan on 24/05/26.
//

import SwiftUI

struct HealthPermissionView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var healthViewModel = HealthCheckViewModel()
    @State private var privacyToggle = false
    @State private var isRequestingPermission = false
    @State private var hasCollectedPermission = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("Your Privacy Matters")
                .multilineTextAlignment(.leading)
                .font(.largeTitle).bold()
                .fontDesign(.rounded)
            Text("Your data is processed locally on this device and will never be shared with other platforms or third parties.")
                .multilineTextAlignment(.leading)
                .font(.title2)
                .fontWeight(.thin)
                .fontDesign(.rounded)
            Toggle(isOn: $privacyToggle) {
                Text("Connect to Apple Health")
            }
            .disabled(isRequestingPermission)
            .onChange(of: privacyToggle) { _, isEnabled in
                guard isEnabled else {
                    hasCollectedPermission = false
                    return
                }

                isRequestingPermission = true
                healthViewModel.checkHealthData {
                    isRequestingPermission = false
                    hasCollectedPermission = true
                }
            }

            if healthViewModel.status != "Not checked yet" {
                Text(healthViewModel.status)
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            Button {
                hasCompletedOnboarding = true
            } label: {
                Text("Next")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .fontDesign(.rounded)
            }
            .foregroundStyle(.white)
            .glassEffect(.regular.tint(.primaryYellow).interactive())
            .disabled(!hasCollectedPermission || isRequestingPermission)
            .opacity(hasCollectedPermission && !isRequestingPermission ? 1 : 0.5)
            .navigationBarBackButtonHidden(true)

        }.padding(20)
    }
}

#Preview {
    HealthPermissionView()
}
