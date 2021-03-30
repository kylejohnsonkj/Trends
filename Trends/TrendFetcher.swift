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

enum DataType: String {
    case locations
    case trending
}

class TrendFetcher: ObservableObject {
    @Published var location: Location
    
    @Published private(set) var trends = [Trend]()
    @Published private(set) var locations = [TrendingLocation]()
    @Published private(set) var dateLastUpdated: Date?
    
    private var testMode: Bool
    
    init(location: Location, testMode: Bool) {
        self.location = location
        self.testMode = testMode
        fetchData(.locations)
        fetchData(.trending)
    }

    // MARK: - Private Implementation
    
    private func filterTrends(_ trends: [Trend]) -> [Trend] {
        return trends.filter { $0.tweetVolume != nil }
    }
    
    private func filterLocations(_ locations: [TrendingLocation]) -> [TrendingLocation] {
        return locations.filter { $0.name == "Worldwide" || $0.placeType.name == "Country" }
    }
    
    public func fetchData(_ type: DataType) {
        if testMode, let path = Bundle.main.path(forResource: type.rawValue, ofType: "json") {
            if let testJsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                if type == .locations {
                    if location.woeid != 1 {
                        self.locations = []
                    } else {
                        parseLocations(json: testJsonData, countriesOnly: false)
                    }
                } else if type == .trending {
                    if location.woeid != 1 {
                        self.trends = []
                        self.dateLastUpdated = nil
                    } else {
                        parseTrends(json: testJsonData)
                    }
                }
            }
            return
        }
        
        if type == .locations {
            twitter.getAvailableTrends { json in
                self.parseLocations(json: json.data ?? Data())
            } failure: { error in
                print(error.localizedDescription)
            }
        } else if type == .trending {
            twitter.getTrendsPlace(with: "\(location.woeid)") { json in
                self.parseTrends(json: json.data ?? Data())
            } failure: { error in
                print(error.localizedDescription)
            }
        }
    }
    
    private func parseLocations(json: Data, countriesOnly: Bool = true) {
        do {
            let locations = try JSONDecoder().decode([TrendingLocation].self, from: json)
            if countriesOnly {
                self.locations = filterLocations(locations).sorted()
            } else {
                self.locations = locations.sorted()
            }
        } catch let error {
            print(error)
        }
    }
    
    private func parseTrends(json: Data) {
        do {
            let trendingItems = try JSONDecoder().decode([TrendingItem].self, from: json)
            if let item = trendingItems.first {
                self.trends = filterTrends(item.trends)
                self.dateLastUpdated = getStringAsDate(input: item.asOf)
            } else {
                self.trends = []
            }
        } catch let error {
            print(error)
        }
    }
    
    private func getStringAsDate(input: String) -> Date? {
        return ISO8601DateFormatter().date(from: input)
    }
}
