//
//  Trend.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import Foundation

struct Trend: Codable, Equatable, Identifiable {
	let name: String
	let url: String
	let promotedContent: String?
	let query: String
	let tweetVolume: Int?
    
    var id: String { name }

	enum CodingKeys: String, CodingKey {
		case name = "name"
		case url = "url"
		case promotedContent = "promoted_content"
		case query = "query"
		case tweetVolume = "tweet_volume"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decode(String.self, forKey: .name)
		url = try values.decode(String.self, forKey: .url)
        promotedContent = try values.decodeIfPresent(String.self, forKey: .promotedContent)     // can be nil
		query = try values.decode(String.self, forKey: .query)
        tweetVolume = try values.decodeIfPresent(Int.self, forKey: .tweetVolume)    // trends with nil here are filtered out
	}
    
    static func == (lhs: Trend, rhs: Trend) -> Bool {
        return lhs.name == rhs.name
            && lhs.url == rhs.url
            && lhs.promotedContent == rhs.promotedContent
            && lhs.query == rhs.query
            && lhs.tweetVolume == rhs.tweetVolume
    }
}
