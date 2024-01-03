//
//  StepQuestiOSWidgetLiveActivity.swift
//  StepQuestiOSWidget
//
//  Created by Dakota Kim on 1/2/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct StepQuestiOSWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct StepQuestiOSWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StepQuestiOSWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension StepQuestiOSWidgetAttributes {
    fileprivate static var preview: StepQuestiOSWidgetAttributes {
        StepQuestiOSWidgetAttributes(name: "World")
    }
}

extension StepQuestiOSWidgetAttributes.ContentState {
    fileprivate static var smiley: StepQuestiOSWidgetAttributes.ContentState {
        StepQuestiOSWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: StepQuestiOSWidgetAttributes.ContentState {
         StepQuestiOSWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: StepQuestiOSWidgetAttributes.preview) {
   StepQuestiOSWidgetLiveActivity()
} contentStates: {
    StepQuestiOSWidgetAttributes.ContentState.smiley
    StepQuestiOSWidgetAttributes.ContentState.starEyes
}
