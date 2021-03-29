//
//  PlaceType.swift
//  Trends
//
//  Created by Kyle Johnson on 3/27/21.
//

import Foundation

struct PlaceType: Codable, Equatable, Hashable {
	let code: Int
	let name: String

	enum CodingKeys: String, CodingKey {
		case code = "code"
		case name = "name"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		code = try values.decode(Int.self, forKey: .code)
		name = try values.decode(String.self, forKey: .name)
	}
}
