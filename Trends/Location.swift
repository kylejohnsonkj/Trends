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
		name = try values.decode(String.self, forKey: .name)
		woeid = try values.decode(Int.self, forKey: .woeid)
	}
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.woeid == rhs.woeid
    }
}
