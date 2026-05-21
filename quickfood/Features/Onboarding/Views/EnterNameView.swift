//
//  EnterNameView.swift
//  quickfood
//
//  Created by Johan on 21/05/26.
//

import SwiftUI

struct EnterNameView: View {
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

                .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 1.5)
                )
            }
            Spacer()
            Button {

            } label: {
                Text("Next")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .fontDesign(.rounded)
            }
            .foregroundStyle(.white)
            .glassEffect(.regular.tint(.primaryRed).interactive())

        }.padding(20)
    }
}

#Preview {
    EnterNameView()
}
