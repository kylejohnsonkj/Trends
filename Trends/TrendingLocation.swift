//
//  TrendingLocation.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import Foundation

struct TrendingLocation: Codable, Equatable, Hashable, Identifiable, Comparable {
	let country: String
	let countryCode: String?
	let name: String
	let parentid: Int
	let placeType: PlaceType
	let url: String
	let woeid: Int
    
    var id: Int { woeid }

	enum CodingKeys: String, CodingKey {
		case country = "country"
		case countryCode = "countryCode"
		case name = "name"
		case parentid = "parentid"
		case placeType = "placeType"
		case url = "url"
		case woeid = "woeid"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		country = try values.decode(String.self, forKey: .country)
		countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)     // can be nil
		name = try values.decode(String.self, forKey: .name)
		parentid = try values.decode(Int.self, forKey: .parentid)
		placeType = try values.decode(PlaceType.self, forKey: .placeType)
		url = try values.decode(String.self, forKey: .url)
		woeid = try values.decode(Int.self, forKey: .woeid)
	}
    
    static func == (lhs: TrendingLocation, rhs: TrendingLocation) -> Bool {
        lhs.woeid == rhs.woeid
    }
    
    static func < (lhs: TrendingLocation, rhs: TrendingLocation) -> Bool {
        if lhs.name == "Worldwide" || rhs.name == "Worldwide" {
            return false
        } else if lhs.name == "United States" || rhs.name == "United States" {
            return true
        } else {
            return lhs.name < rhs.name
        }
    }
}
