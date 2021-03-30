//
//  TrendingView.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import SwiftUI

struct TrendingView: View {
    @State private var location: Location
    
    @ObservedObject var trendFetcher: TrendFetcher

    var locations: [TrendingLocation] { trendFetcher.locations }
    var trends: [Trend] { trendFetcher.trends }
    var dateLastUpdated: Date? { trendFetcher.dateLastUpdated }
    
    init(location: Location, testMode: Bool) {
        _location = State(wrappedValue: location)
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
            .navigationBarItems(leading: filter, trailing: lastUpdated)
        }
        .onChange(of: location) { _ in
            trendFetcher.location = location
            trendFetcher.fetchData(.trending)
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
    
    var lastUpdated: some View {
        Button(action: {
            trendFetcher.fetchData(.trending)
        }, label: {
            if let date = dateLastUpdated {
                Text(DateFormatter.shortTime.string(from: date))
                Image(systemName: "clock.arrow.2.circlepath")
            }
        })
    }
}

struct TrendingListEntry: View {
    var trend: Trend

    var body: some View {
        Link(destination: URL(string: trend.url)!) {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView(location: worldwide, testMode: true)
    }
}
