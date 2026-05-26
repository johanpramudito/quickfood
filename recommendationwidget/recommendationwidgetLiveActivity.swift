//
//  recommendationwidgetLiveActivity.swift
//  recommendationwidget
//

import ActivityKit
import SwiftUI
import WidgetKit

struct recommendationwidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var emoji: String
    }

    var name: String
}

struct recommendationwidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: recommendationwidgetAttributes.self) { context in
            VStack {
                Text("QuickFood")
                Text(context.state.emoji)
            }
            .activityBackgroundTint(Color.orange)
            .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("QuickFood")
                }

                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.emoji)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.attributes.name)
                }
            } compactLeading: {
                Text("QF")
            } compactTrailing: {
                Text(context.state.emoji)
            } minimal: {
                Text(context.state.emoji)
            }
        }
    }
}

extension recommendationwidgetAttributes {
    fileprivate static var preview: recommendationwidgetAttributes {
        recommendationwidgetAttributes(name: "QuickFood")
    }
}

extension recommendationwidgetAttributes.ContentState {
    fileprivate static var smiley: recommendationwidgetAttributes.ContentState {
        recommendationwidgetAttributes.ContentState(emoji: "🙂")
    }
}

#Preview("Notification", as: .content, using: recommendationwidgetAttributes.preview) {
    recommendationwidgetLiveActivity()
} contentStates: {
    recommendationwidgetAttributes.ContentState.smiley
}
