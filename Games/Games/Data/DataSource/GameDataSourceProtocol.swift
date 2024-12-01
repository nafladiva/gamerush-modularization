//
//  GameDataSourceProtocol.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Combine
import Foundation

protocol GameDataSourceProtocol {
    func getGames() -> AnyPublisher<GamesResponses, Error>
    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailResponse, Error>
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
