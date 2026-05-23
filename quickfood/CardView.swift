//
//  CardView.swift
//  quickfood
//
//  Created by Muhammad Najmi Rahmani  on 22/05/26.
//

import SwiftUI
import SwiftData

struct CardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var offset: CGSize = .zero
    
    @State var foodsData: Food

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(foodsData.name)")
                        .foregroundStyle(Color.white)
                        .font(.title.bold())
                    
                    HStack(spacing: 8) {
                        ForEach(foodsData.tags, id: \.self) { tag in
                            HStack(spacing: 4) {
                                Text("\(tag)")
                                    .foregroundStyle(Color.black)
                            }
                            .frame(width: 102, height: 31)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(20)
                        }
                    }
                    
                    Divider()
                    
                    Text("\(foodsData.notes)")
                        .font(.callout)
                        .foregroundStyle(Color.white)
                }
                .padding(16)
                .padding(.top, 252)
            }
            .frame(width: 362, height: 460, alignment: .leading)
            .background(
                Image("Sayurasem")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
            .cornerRadius(24)
            .padding(16)
            .padding(.top, 252)
            //        .blur(radius: 0.1)
        }
        .offset(x: offset.width, y: offset.height * 0)
        .rotationEffect(.degrees(Double(offset.width / 30)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
            
                .onEnded { _ in
                    if offset.width > 150 {
                        Swiped()
                    }
                    else if offset.width < -150 {
                        Swiped()
                    }
                    else {
                        offset = .zero
                    }
                }
        )
        .animation(.spring(), value: offset)
    }
    
    func Swiped() {
        // Put to the last index
        
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        let cardscale = 1 - (offset * 0.05)
            
        return self
            .scaleEffect(cardscale)
            .offset(y: 25 * offset)
        
    }
}

struct PreviewCard: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort:\Food.name) private var foodsData: [Food]
    
    var body: some View {
        Button {
            seedFoodsIfNeeded(modelContext: modelContext)
        } label: {
            Text("Generate Food")
        }
        .buttonStyle(.borderedProminent)
        
        ZStack {
            ForEach(foodsData) { food in
                CardView(foodsData: food)
            }
        }
    }
}


#Preview {
//    CardView(
//        foodsData: Food(
//            name: "Bubur Ayam Jahe",
//            category: "Comfort Meal",
//            tags: ["Chicken", "Ginger", "Warm"],
//            cyclePhase: "menstruationPhase",
//            notes: "Warm, gentle meal with protein and ginger."
//        )
//    )
    
    PreviewCard()
}
