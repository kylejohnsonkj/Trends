//
//  Location.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import Foundation

struct Location: Codable, Equatable, Hashable {
	let name: String
	let woeid: Int

	enum CodingKeys: String, CodingKey {
		case name = "name"
		case woeid = "woeid"
	}
    
    init(name: String, woeid: Int) {
        self.name = name
        self.woeid = woeid
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name) ?? "N/A"
		woeid = try values.decodeIfPresent(Int.self, forKey: .woeid) ?? -1
	}
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.woeid == rhs.woeid
    }
}
