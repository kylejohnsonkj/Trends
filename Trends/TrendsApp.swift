//
//  TrendsApp.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import SwiftUI
import SwifteriOS

// MARK: REPLACE NIL WITH YOUR OWN CREDENTIALS TO SHOW REAL DATA
let apiKey: String? = nil
let apiSecretKey: String? = nil

var twitter: Swifter! = {
    if let apiKey = apiKey, let apiSecretKey = apiSecretKey {
        return Swifter(consumerKey: apiKey, consumerSecret: apiSecretKey)
    }
    return nil
}()

let worldwide = Location(name: "Worldwide", woeid: 1)

@main
struct TrendsApp: App {
    var body: some Scene {
        WindowGroup {
            TrendingView(location: worldwide, testMode: false)
        }
    }
}
