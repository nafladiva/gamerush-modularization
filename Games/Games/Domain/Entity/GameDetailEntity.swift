//
//  GameDetailEntity.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Foundation
import UIKit

struct GameDetailEntity {
    var id: Int
    var name: String
    var descriptionRaw: String
    var released: String
    var backgroundImage: UIImage?
    var website: String
    var rating: Double
    var developers: [DeveloperEntity]
    var genres: [GenreEntity]
    var publishers: [PublisherEntity]
}
