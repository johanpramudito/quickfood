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
            Text("Personalized recommendations powered by your cycle and preferences.")
                .multilineTextAlignment(.leading)
                .font(.title2)
                .fontWeight(.thin)
            VStack(alignment: .leading, spacing: 8){
                Text("Enter your name")
                    .font(.headline)
                    .fontWeight(.semibold)
                TextField(
                    "John Doe",
                    text: $nama)
                .padding(16)
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
            }
            .foregroundStyle(.white)
            .glassEffect(.regular.tint(.primaryRed).interactive())

        }.padding(20)
    }
}

#Preview {
    EnterNameView()
}
