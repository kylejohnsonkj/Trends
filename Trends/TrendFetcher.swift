//
//  TrendFetcher.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import SwiftUI

enum DataType: String {
    case locations
    case trending
}

class TrendFetcher: ObservableObject {
    var location: Location
    private var useFakeData: Bool
    
    @Published private(set) var trends = [Trend]()
    @Published private(set) var locations = [TrendingLocation]()
    @Published private(set) var dateLastUpdated: Date?
    
    init(location: Location, _ useFakeData: Bool) {
        self.location = location
        self.useFakeData = useFakeData
        fetchData(.locations)
        fetchData(.trending)
    }
    
    func fetchData(_ type: DataType) {
        if useFakeData {
            fetchFakeData(type)
        } else {
            fetchRealData(type)
        }
    }
    
    // MARK: - Private Implementation
    
    private func fetchFakeData(_ dataType: DataType) {
        // fetch fake data for testing/preview purposes
        guard let path = Bundle.main.path(forResource: dataType.rawValue, ofType: "json"),
              let testJsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }
        
        switch dataType {
        case .locations:
            parseLocations(json: testJsonData, countriesOnly: false)
        case .trending:
            if location.woeid != 1 {
                trends = []
                dateLastUpdated = nil
            } else {
                parseTrends(json: testJsonData)
            }
        }
    }
    
    private func fetchRealData(_ type: DataType) {
        // fetch live data from api
        if type == .locations {
            twitter.getAvailableTrends { json in
                self.parseLocations(json: json.data, countriesOnly: true)
            } failure: { error in
                print(error.localizedDescription)
            }
        } else if type == .trending {
            twitter.getTrendsPlace(with: "\(location.woeid)") { json in
                self.parseTrends(json: json.data)
            } failure: { error in
                print(error.localizedDescription)
            }
        }
    }
    
    private func parseLocations(json: Data?, countriesOnly: Bool) {
        do {
            let locationItems = try JSONDecoder().decode([TrendingLocation].self, from: json ?? Data())
            if countriesOnly {
                locations = filterLocations(locationItems).sorted()
            } else {
                locations = locationItems.sorted()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func parseTrends(json: Data?) {
        do {
            let trendingItems = try JSONDecoder().decode([TrendingItem].self, from: json ?? Data())
            if let item = trendingItems.first {
                trends = filterTrends(item.trends)
                dateLastUpdated = getStringAsDate(input: item.asOf)
            } else {
                trends = []
                dateLastUpdated = nil
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Helpers
    
    private func filterTrends(_ trends: [Trend]) -> [Trend] {
        return trends.filter { $0.tweetVolume != nil }
    }
    
    private func filterLocations(_ locations: [TrendingLocation]) -> [TrendingLocation] {
        return locations.filter { $0.name == "Worldwide" || $0.placeType.name == "Country" }
    }
    
    private func getStringAsDate(input: String) -> Date? {
        return ISO8601DateFormatter().date(from: input)
    }
}
