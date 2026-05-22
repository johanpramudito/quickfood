//
//  ProfileView.swift
//  quickfood
//
//  Created by Bintang Marsyuma Rakhasunu on 20/05/26.
//
import SwiftUI

struct Profile: View {
    @State private var isEnabled: Bool = true
    var User: UserProfile
    var body: some View {
        VStack{
            HStack{
                Text("Hi, Marwani")
                    .font(Font.largeTitle)
                    .bold()
                Image(systemName: "pencil.circle.fill")
                    .font(Font.largeTitle)
                    .foregroundStyle(Color.orange)
            }
            
            Text("Your allergy settings")
                .padding(.top, 5)
                .padding(.bottom, 10)
                
            List{
                
                Toggle("Egg", isOn: $isEnabled)
                    .tint(.orange)
            }
            .cornerRadius(20)
            .frame(height: 300)
            
        }
        .padding(20)
    }
}

#Preview {
    Profile(User: UserProfile(id: 1, displayName: "Marwani"))
}
