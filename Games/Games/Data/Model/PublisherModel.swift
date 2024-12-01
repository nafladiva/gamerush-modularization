//
//  PublisherModel.swift
//  GameRush
//
//  Created by Nafla Diva Syafia (ID) on 12/11/24.
//

import Foundation

struct PublisherResponse: Codable {
    let id: Int
    let name: String
    let gamesCount: Int
    let imageBackground: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.gamesCount = try container.decode(Int.self, forKey: .gamesCount)
        self.imageBackground = try container.decode(String.self, forKey: .imageBackground)
    }
}
