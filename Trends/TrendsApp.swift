//
//  TrendsApp.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import SwiftUI

let worldwide = Location(name: "Worldwide", woeid: 1)

@main
struct TrendsApp: App {
    var body: some Scene {
        WindowGroup {
            TrendingView(location: worldwide, testMode: false)
        }
    }
}

extension DateFormatter {
    static var short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static var shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static var shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}
