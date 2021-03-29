//
//  TrendingView.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import SwiftUI

struct TrendingView: View {
    @State private var location: Location
    @State private var testMode: Bool
    
    @ObservedObject var trendFetcher: TrendFetcher

    var locations: [TrendingLocation] { trendFetcher.locations }
    var trends: [Trend] { trendFetcher.trends }
    
    init(location: Location, testMode: Bool) {
        _location = State(wrappedValue: location)
        _testMode = State(wrappedValue: testMode)
        
        trendFetcher = TrendFetcher(location: location, testMode: testMode)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(trends) { trend in
                    TrendingListEntry(trend: trend)
                }
            }
            .navigationBarTitle("Trending")
            .navigationBarItems(leading: filter)
        }
        .onChange(of: location) { _ in
            trendFetcher.location = location
            trendFetcher.fetchTrending()
        }
    }
    
    @State private var showFilter = false

    var filter: some View {
        Button(action: {
            self.showFilter = true
        }, label: {
            Image(systemName: "location.fill")
            Text(location.name)
        })
        .sheet(isPresented: $showFilter) {
            FilterTrends(location: $location, isPresented: $showFilter, list: locations)
        }
    }
}

struct TrendingListEntry: View {
    var trend: Trend

    var body: some View {
        VStack(alignment: .leading) {
            Text(trend.name)
                .bold()
            Text("\(trend.tweetVolume ?? 0) tweets")
                .font(.callout)
                .foregroundColor(.blue)
        }
        .lineLimit(1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView(location: worldwide, testMode: true)
    }
}
