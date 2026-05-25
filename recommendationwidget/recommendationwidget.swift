//
//  recommendationwidget.swift
//  recommendationwidget
//
//  Created by Johan on 25/05/26.
//

import WidgetKit
import SwiftUI
import UIKit

struct WidgetFood: Decodable, Hashable {
    let name: String
    let category: String
    let tags: [String]
    let nutrition: [String]
    let cyclePhase: String
    let notes: String
    let image: String
}

struct FoodEntry: TimelineEntry {
    let date: Date
    let food: WidgetFood
    let imageData: Data?
}

final class CompletionState: @unchecked Sendable {
    private let lock = NSLock()
    private var isComplete = false

    func completeOnce(_ completion: () -> Void) {
        lock.lock()
        defer { lock.unlock() }

        guard !isComplete else {
            return
        }

        isComplete = true
        completion()
    }
}

struct Provider: TimelineProvider {
    private let supabaseURL = "https://vlusefqntgrzetlqvulu.supabase.co/storage/v1/object/public/FoodCycle"

    func placeholder(in context: Context) -> FoodEntry {
        FoodEntry(date: Date(), food: .sample, imageData: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (FoodEntry) -> Void) {
        loadEntry(for: context.family, completion: completion)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FoodEntry>) -> Void) {
        loadEntry(for: context.family) { entry in
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 6, to: Date()) ?? Date()
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }

    private func loadEntry(for family: WidgetFamily, completion: @escaping (FoodEntry) -> Void) {
        let food = loadFood()
        loadImageData(for: food, targetSize: imageSize(for: family)) { imageData in
            DispatchQueue.main.async {
                completion(FoodEntry(date: Date(), food: food, imageData: imageData))
            }
        }
    }

    private func loadFood() -> WidgetFood {
        guard let url = Bundle.main.url(forResource: "foods", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let foods = try? JSONDecoder().decode([WidgetFood].self, from: data),
              let food = foods.randomElement()
        else {
            return .sample
        }

        return food
    }

    private func imageURL(for food: WidgetFood) -> URL? {
        URL(string: supabaseURL)?
            .appendingPathComponent(food.image)
            .appendingPathExtension("jpg")
    }

    private func loadImageData(for food: WidgetFood, targetSize: CGSize, completion: @escaping (Data?) -> Void) {
        guard let url = imageURL(for: food) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 3
        request.cachePolicy = .returnCacheDataElseLoad

        let didComplete = CompletionState()
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            didComplete.completeOnce {
                completion(nil)
            }
        }

        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data,
                  let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode)
            else {
                didComplete.completeOnce {
                    completion(nil)
                }
                return
            }

            let imageData = resizedImageData(from: data, targetSize: targetSize)
            didComplete.completeOnce {
                completion(imageData)
            }
        }.resume()
    }

    private func imageSize(for family: WidgetFamily) -> CGSize {
        switch family {
        case .systemMedium:
            return CGSize(width: 1_014, height: 474)
        default:
            return CGSize(width: 474, height: 474)
        }
    }

    private func resizedImageData(from data: Data, targetSize: CGSize) -> Data? {
        guard let image = UIImage(data: data) else {
            return nil
        }

        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height
        let scale = max(widthRatio, heightRatio)
        let scaledSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let drawOrigin = CGPoint(
            x: (targetSize.width - scaledSize.width) / 2,
            y: (targetSize.height - scaledSize.height) / 2
        )

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        format.opaque = true

        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: drawOrigin, size: scaledSize))
        }

        return resizedImage.jpegData(compressionQuality: 0.72)
    }
}

struct RecommendationWidgetEntryView: View {
    let entry: FoodEntry

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            foodImage
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.72), .clear],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 6) {
                Text("Recommended")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.85))

                Text(entry.food.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                HStack(spacing: 4) {
                    ForEach(entry.food.nutrition.prefix(2), id: \.self) { nutrition in
                        Text(nutrition)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.white.opacity(0.75))
                            .clipShape(Capsule())
                    }
                }

                Text(entry.food.notes)
                    .font(.caption2)
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var foodImage: some View {
        if let imageData = entry.imageData,
           let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.66, blue: 0.12), Color.orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct recommendationwidget: Widget {
    let kind = "recommendationwidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RecommendationWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Food Recommendation")
        .description("Shows a recommended food from QuickFood.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

private extension WidgetFood {
    static let sample = WidgetFood(
        name: "Gulai Ayam",
        category: "Lauk Pauk Basah Berkuah",
        tags: ["Chicken", "Curry"],
        nutrition: ["Healthy fats", "Protein"],
        cyclePhase: "lutealPhase",
        notes: "Soupy side dish with Chicken, Curry - good protein source.",
        image: "gulai-ayam"
    )
}

#Preview(as: .systemSmall) {
    recommendationwidget()
} timeline: {
    FoodEntry(date: .now, food: .sample, imageData: nil)
}

#Preview(as: .systemMedium) {
    recommendationwidget()
} timeline: {
    FoodEntry(date: .now, food: .sample, imageData: nil)
}
