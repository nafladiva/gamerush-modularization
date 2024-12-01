//
//  GameRepositoryProtocol.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Combine
import Foundation

protocol FavoriteRepositoryProtocol {
    func getFavorites() -> AnyPublisher<[FavoriteEntity], Error>
}
