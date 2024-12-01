//
//  GameRepositoryProtocol.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Combine
import Foundation

protocol GameRepositoryProtocol {
    func getGames() -> AnyPublisher<[GameEntity], Error>
    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailEntity, Error>
    func checkFavoriteStatus(gameId: Int) -> AnyPublisher<Bool, Error>
    func addFavorite(
        _ id: Int,
        _ name: String,
        _ image: Data,
        _ genres: String,
        _ released: String,
        _ rating: Double
    ) -> AnyPublisher<Bool, Error>
    func removeFavorite(gameId: Int) -> AnyPublisher<Bool, Error>
}
