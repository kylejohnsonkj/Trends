//
//  TrendingItem.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import Foundation

struct TrendingItem: Codable, Equatable {
	let trends: [Trend]
	let asOf: String
	let createdAt: String
	let locations: [Location]

	enum CodingKeys: String, CodingKey {
		case trends = "trends"
		case asOf = "as_of"
		case createdAt = "created_at"
		case locations = "locations"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		trends = try values.decode([Trend].self, forKey: .trends)
        asOf = try values.decode(String.self, forKey: .asOf)
        createdAt = try values.decode(String.self, forKey: .createdAt)
		locations = try values.decode([Location].self, forKey: .locations)
	}
    
    static func == (lhs: TrendingItem, rhs: TrendingItem) -> Bool {
        return lhs.trends == rhs.trends
            && lhs.asOf == rhs.asOf
            && lhs.createdAt == rhs.createdAt
            && lhs.locations == rhs.locations
    }
}
