//
//  TrendingView.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import SwiftUI

struct TrendingView: View {
    @State private var location: Location
    private var useFakeData: Bool
    
    @ObservedObject private var trendFetcher: TrendFetcher
    
    private var locations: [TrendingLocation] { trendFetcher.locations }
    private var trends: [Trend] { trendFetcher.trends }
    private var dateLastUpdated: Date? { trendFetcher.dateLastUpdated }
    
    init(location: Location, testMode: Bool) {
        useFakeData = testMode || twitter == nil
        let storedLocation = Storage.getLocationFromDefaults() ?? location
        let locationToUse = useFakeData ? location : storedLocation
        
        _location = State(wrappedValue: locationToUse)
        trendFetcher = TrendFetcher(location: locationToUse, useFakeData)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(trends) { trend in
                    TrendingListEntry(trend: trend)
                }
            }
            .navigationBarTitle("Trending")
            .navigationBarItems(leading: filter, trailing: refresh)
        }
        .onChange(of: location) { _ in
            updateLocation()
        }
    }
    
    private func updateLocation() {
        trendFetcher.location = location
        trendFetcher.fetchData(.trending)

        if !useFakeData {
            Storage.saveLocationToDefaults(location)
        }
    }
    
    @State private var showFilter = false
    
    var filter: some View {
        Button(action: {
            showFilter = true
        }, label: {
            Image(systemName: "location.fill")
            Text(location.name)
        })
        .sheet(isPresented: $showFilter) {
            FilterTrends(location: $location, list: locations, isPresented: $showFilter)
        }
    }
    
    var refresh: some View {
        Button(action: {
            trendFetcher.fetchData(.trending)
        }, label: {
            if let date = dateLastUpdated {
                Text(DateFormatter.shortTime.string(from: date))
                Image(systemName: "clock.fill")
            }
        })
    }
}

struct TrendingListEntry: View {
    let trend: Trend
    var url: URL { URL(string: trend.url)! }
    
    var body: some View {
        Link(destination: url) {
            VStack(alignment: .leading) {
                Text(trend.name)
                    .bold()
                Text("\(trend.tweetVolume ?? 0) tweets")
                    .font(.callout)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView(location: worldwide, testMode: true)
//            .colorScheme(.dark)
    }
}
