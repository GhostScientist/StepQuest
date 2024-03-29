//
//  StepQuestWatchWidget.swift
//  StepQuestWatchWidget
//
//  Created by Dakota Kim on 1/2/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct StepQuestWatchWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            HStack {
                ProgressView(value: 6000.0, total: 10000).progressViewStyle(CircularProgressViewStyle())
                    .padding()
                Text("60%")
                    .font(.largeTitle)
                    .bold()
                
            }
        }
        .containerBackground(.blue.gradient, for: .widget)
        

    }
}

@main
struct StepQuestWatchWidget: Widget {
    let kind: String = "StepQuestWatchWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                StepQuestWatchWidgetEntryView(entry: entry)
                    
            } else {
                StepQuestWatchWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .accessoryRectangular) {
    StepQuestWatchWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
