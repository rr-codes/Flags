//
//  FlagsWidget.swift
//  FlagsWidget
//
//  Created by Richard Robinson on 2021-05-31.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let provider = FlagProvider()
    
    func placeholder(in context: Context) -> SimpleEntry {
        let currentDate = Date()
        let country = provider.countryOfTheDay(for: currentDate)
        
        return SimpleEntry(date: currentDate, country: country)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let currentDate = Date()
        let country = provider.countryOfTheDay(for: currentDate)
        
        let entry = SimpleEntry(date: currentDate, country: country)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        
        let country = provider.countryOfTheDay(for: nextMidnight)
        
        let entries = [
            SimpleEntry(date: nextMidnight, country: country)
        ]
        
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let country: Country
}

struct FlagsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Image(entry.country.flagImageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .widgetURL(widgetUrl)
    }
    
    var widgetUrl: URL? {
        var components = URLComponents()
        components.scheme = "com.richardrobinson.flags"
        components.host = "flags"
        components.path = "/\(entry.country.id)"
        
        return components.url
    }
}

@main
struct FlagsWidget: Widget {
    let kind: String = "FlagsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FlagsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct FlagsWidget_Previews: PreviewProvider {
    static let entry = SimpleEntry(date: Date(), country: FlagProvider().countryOfTheDay(for: Date()))
    
    static var previews: some View {
        FlagsWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
