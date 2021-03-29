//
//  TrendFetcher.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import SwiftUI
import Combine
import SwifteriOS

let apiKey = "***REMOVED***"
let apiSecretKey = "***REMOVED***"
let twitter = Swifter(consumerKey: apiKey, consumerSecret: apiSecretKey)

class TrendFetcher: ObservableObject {
    @State var testMode: Bool
    
    init(location: Location, testMode: Bool) {
        self.location = location
        self.testMode = testMode
        fetchLocations()
        fetchTrending()
    }

    @Published var location: Location
    
    @Published private(set) var trends = [Trend]()
    @Published private(set) var locations = [TrendingLocation]()

    // MARK: - Private Implementation
    
    private func filterTrends(_ trends: [Trend]) -> [Trend] {
        return trends.filter { $0.tweetVolume != nil }
    }
    
    private func filterLocations(_ locations: [TrendingLocation]) -> [TrendingLocation] {
        return locations.filter { $0.name == "Worldwide" || $0.placeType.name == "Country" }
    }
    
    private func fetchLocations() {
        if testMode, let path = Bundle.main.path(forResource: "locations", ofType: "json") {
            if let testJsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                if location.woeid != 1 {
                    self.locations = []
                    return
                }
                parseLocations(json: testJsonData, countriesOnly: false)
                return
            }
        }
        
        twitter.getAvailableTrends { json in
            self.parseLocations(json: json.data ?? Data())
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    private func parseLocations(json: Data, countriesOnly: Bool = true) {
        do {
            let locations = try JSONDecoder().decode([TrendingLocation].self, from: json)
            if countriesOnly {
                self.locations = filterLocations(locations)
            } else {
                self.locations = locations
            }
        } catch let error {
            print(error)
        }
    }
    
    public func fetchTrending() {
        if testMode, let path = Bundle.main.path(forResource: "trending", ofType: "json") {
            if let testJsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                if location.woeid != 1 {
                    self.trends = []
                    return
                }
                parseTrends(json: testJsonData)
                return
            }
        }
        
        twitter.getTrendsPlace(with: "\(location.woeid)") { json in
            self.parseTrends(json: json.data ?? Data())
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    private func parseTrends(json: Data) {
        do {
            let trendingItems = try JSONDecoder().decode([TrendingItem].self, from: json)
            self.trends = filterTrends(trendingItems.first?.trends ?? [])
        } catch let error {
            print(error)
        }
    }
}
