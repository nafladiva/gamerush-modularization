//
//  GameModel.swift
//  GameRush
//
//  Created by Nafla Diva Syafia (ID) on 12/11/24.
//

import Foundation
import UIKit

struct GamesResponses: Codable {
    let count: Int
    let results: [GameResponse]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.results = try container.decode([GameResponse].self, forKey: .results)
    }
}

struct GameResponse: Codable {
    let id: Int
    let name: String
    let released: String
    let backgroundImage: String
    let rating: Double
    let genres: [GenreResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case genres
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.released = try container.decode(String.self, forKey: .released)
        self.backgroundImage = try container.decode(String.self, forKey: .backgroundImage)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.genres = try container.decode([GenreResponse].self, forKey: .genres)
    }
}
