//
//  Storage.swift
//  Trends
//
//  Created by Kyle Johnson on 4/4/21.
//

import Foundation

struct Storage {
    private static let LocationKey = "Trends.LocationKey"
    
    static func saveLocationToDefaults(_ location: Location) {
        if let encoded = try? JSONEncoder().encode(location) {
            UserDefaults.standard.set(encoded, forKey: Storage.LocationKey)
        }
    }
    
    static func getLocationFromDefaults() -> Location? {
        if let encoded = UserDefaults.standard.object(forKey: Storage.LocationKey) as? Data,
           let location = try? JSONDecoder().decode(Location.self, from: encoded) {
            return location
        }
        return nil
    }
}
