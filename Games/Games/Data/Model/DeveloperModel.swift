//
//  DeveloperModel.swift
//  GameRush
//
//  Created by Nafla Diva Syafia (ID) on 12/11/24.
//

import Foundation

struct DeveloperResponse: Codable {
    let id: Int
    let name: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
