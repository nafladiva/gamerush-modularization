//
//  GameDataSourceProtocol.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Combine
import Foundation

protocol GameDataSourceProtocol {
    func getGamesV2() -> AnyPublisher<GamesResponses, Error>
    func getGameDetailV2(gameId: Int) -> AnyPublisher<GameDetailResponse, Error>
    func getFavorites() -> AnyPublisher<[FavoriteEntity], Error>
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
