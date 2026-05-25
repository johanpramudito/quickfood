//
//  recommendationwidgetControl.swift
//  recommendationwidget
//
//  Created by Johan on 25/05/26.
//

import AppIntents
import SwiftUI
import WidgetKit

struct recommendationwidgetControl: ControlWidget {
    static let kind = "com.johan.quickfood.recommendationwidget"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: OpenAppIntent()) {
                Label("Open QuickFood", systemImage: "fork.knife")
            }
        }
        .displayName("QuickFood")
        .description("Open QuickFood.")
    }
}

struct OpenAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Open QuickFood"
    static var openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        .result()
    }
}
