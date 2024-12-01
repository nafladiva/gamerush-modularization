//
//  GameDetailModel.swift
//  GameRush
//
//  Created by Nafla Diva Syafia (ID) on 12/11/24.
//

import Foundation
import UIKit

struct GameDetailResponse: Codable {
    let id: Int
    let name: String
    let descriptionRaw: String
    let released: String
    let backgroundImage: String
    let website: String
    let rating: Double
    let developers: [DeveloperResponse]
    let genres: [GenreResponse]
    let publishers: [PublisherResponse]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptionRaw = "description_raw"
        case released
        case backgroundImage = "background_image"
        case website
        case rating
        case developers
        case genres
        case publishers
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.descriptionRaw = try container.decode(String.self, forKey: .descriptionRaw)
        self.released = try container.decode(String.self, forKey: .released)
        self.backgroundImage = try container.decode(String.self, forKey: .backgroundImage)
        self.website = try container.decode(String.self, forKey: .website)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.developers = try container.decode([DeveloperResponse].self, forKey: .developers)
        self.genres = try container.decode([GenreResponse].self, forKey: .genres)
        self.publishers = try container.decode([PublisherResponse].self, forKey: .publishers)
    }
}
