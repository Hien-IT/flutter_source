//
//  lich_viet.swift
//  lich-viet
//
//  Created by Hiển Nguyễn on 11/01/2023.
//

import WidgetKit
import SwiftUI

private let widgetGroupId = "group.com.lichviet"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Placeholder Title", message: "Placeholder Message")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = UserDefaults.init(suiteName:widgetGroupId)
              let entry = SimpleEntry(date: Date(), title: data?.string(forKey: "title") ?? "No Title Set", message: data?.string(forKey: "message") ?? "No Message Set")
              completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
                   let timeline = Timeline(entries: [entry], policy: .atEnd)
                   completion(timeline)
               }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let message: String
}

struct lich_vietEntryView : View {
    var entry: Provider.Entry
        let data = UserDefaults.init(suiteName:widgetGroupId)
        
        var body: some View {
            VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text(entry.title).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text(entry.message)
                    .font(.body)
                    .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.message)&homeWidget"))
            }
            )
        }}

struct lich_viet: Widget {
    let kind: String = "lich_viet"

    var body: some WidgetConfiguration {
           StaticConfiguration(kind: kind, provider: Provider()) { entry in
               lich_vietEntryView(entry: entry)
           }
           .configurationDisplayName("My Widget")
           .description("This is an example widget.")
       }
}

struct lich_viet_Previews: PreviewProvider {
    static var previews: some View {
        lich_vietEntryView(entry: SimpleEntry(date: Date(), title: "Example Title", message: "Example Message"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
}
