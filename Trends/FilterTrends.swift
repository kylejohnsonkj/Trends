//
//  FilterTrends.swift
//  Trends
//
//  Created by Kyle Johnson on 3/28/21.
//

import SwiftUI

struct FilterTrends: View {
    @Binding var location: Location
    @Binding var isPresented: Bool
    
    @State private var trendingLocations: [TrendingLocation?]
    @State private var draftTrendingLocation: TrendingLocation?
    
    init(location: Binding<Location>, isPresented: Binding<Bool>, list: [TrendingLocation]) {
        _location = location
        _isPresented = isPresented
        _draftTrendingLocation = State(wrappedValue: list.filter {
            $0.woeid == location.wrappedValue.woeid }.first )
        _trendingLocations = State(wrappedValue: list)
    }
    
//    func locationAsTrendingLocation(location: Location) -> Binding<TrendingLocation> {
//        return trendingLocations.filter { $0.woeid == location.woeid }.first
//    }
    
    var containsWorldwide: Bool {
        trendingLocations.contains { $0?.name == "Worldwide" }
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
            self.isPresented = false
        }
    }
    var done: some View {
        Button("Done") {
            if let location = draftTrendingLocation {
                self.location = Location(name: location.name, woeid: location.woeid)
            } else {
                self.location = worldwide
            }
            self.isPresented = false
        }
    }
}
