//
//  FilterTrends.swift
//  Trends
//
//  Created by Kyle Johnson on 3/28/21.
//

import SwiftUI

struct FilterTrends: View {
    @Binding private var location: Location
    @Binding private var isPresented: Bool
    
    @State private var trendingLocations: [TrendingLocation?]
    @State private var draftTrendingLocation: TrendingLocation?
    
    init(location: Binding<Location>, list: [TrendingLocation], isPresented: Binding<Bool>) {
        _location = location
        _trendingLocations = State(wrappedValue: list)
        _draftTrendingLocation = State(wrappedValue: list.filter {
            $0.woeid == location.wrappedValue.woeid }.first )
        _isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Location", selection: $draftTrendingLocation) {
                    if !containsWorldwide {
                        Text("Worldwide").tag(TrendingLocation?.none)
                    }
                    ForEach(trendingLocations, id: \.self) { location in
                        if let location = location {
                            Text("\(location.name)").tag(location)
                        }
                    }
                }
            }
            .navigationBarTitle("Choose Location")
            .navigationBarItems(leading: cancel, trailing: done)
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
            isPresented = false
        }
    }
    
    var done: some View {
        Button("Done") {
            if let draftLocation = draftTrendingLocation {
                location = Location(name: draftLocation.name, woeid: draftLocation.woeid)
            } else {
                location = worldwide
            }
            isPresented = false
        }
    }
    
    // MARK: - Helpers
    
    private var containsWorldwide: Bool {
        trendingLocations.contains { $0?.name == "Worldwide" }
    }
}
