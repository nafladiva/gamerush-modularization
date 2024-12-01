//
//  GameEntity.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Foundation
import UIKit

struct GameEntity {
    var id: Int
    var name: String
    var released: String
    var backgroundImage: UIImage?
    var rating: Double
    var genres: [GenreEntity]
}
