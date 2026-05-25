//
//  AppIntent.swift
//  recommendationwidget
//

import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "Configure the widget." }

    @Parameter(title: "Name", default: "Food Recommendation")
    var timerName: String
}
