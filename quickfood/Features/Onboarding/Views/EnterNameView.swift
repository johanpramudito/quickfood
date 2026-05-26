//
//  EnterNameView.swift
//  quickfood
//
//  Created by Johan on 21/05/26.
//

import SwiftUI

struct EnterNameView: View {
    @AppStorage("userName") private var userName = ""
    @State private var navigateToAvoidFood = false
    
    @State private var nama:String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("Discover food that fits your body today.")
                .multilineTextAlignment(.leading)
                .font(.largeTitle).bold()
                .fontDesign(.rounded)
            Text("Personalized recommendations powered by your cycle and preferences.")
                .multilineTextAlignment(.leading)
                .font(.title2)
                .fontWeight(.thin)
                .fontDesign(.rounded)
            VStack(alignment: .leading, spacing: 8){
                Text("Enter your name")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                TextField(
                    "John Doe",
                    text: $nama)
                .padding(16)
                .fontDesign(.rounded)
                .keyboardType(.namePhonePad)
                .textContentType(.name)
                .submitLabel(.next)
                .onSubmit { /* navigate next */ }

                .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary, lineWidth: 1.5)
                )
            }
            Spacer()
            Button {
                guard nama != "" else {
                    return
                }
                userName = nama
                navigateToAvoidFood = true
                
            } label: {
                Text("Next")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .fontDesign(.rounded)
            }
            .disabled(nama.isEmpty)
            .accessibilityHint(nama.isEmpty ? "Enter your name first" : "")
            .foregroundStyle(.white)
            .glassEffect(.regular.tint(.primaryYellow).interactive())
            .navigationDestination(isPresented: $navigateToAvoidFood) {
                AvoidFoodView()
            }
//            .navigationBarBackButtonHidden(true)

        }.padding(20)
            .background(.primaryBackground)
    }
}

#Preview {
    EnterNameView()
}
