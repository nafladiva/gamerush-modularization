//
//  GameInteractor.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Combine
import Foundation

class GameInteractor: GameUseCase {

    private let repository: GameRepositoryProtocol

    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    func getGames() -> AnyPublisher<[GameEntity], any Error> {
        return repository.getGames()
    }

    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailEntity, any Error> {
        return repository.getGameDetail(gameId: gameId)
    }

    func checkFavoriteStatus(gameId: Int) -> AnyPublisher<Bool, any Error> {
        return repository.checkFavoriteStatus(gameId: gameId)
    }

    func addFavorite(_ id: Int, _ name: String, _ image: Data, _ genres: String, _ released: String, _ rating: Double) -> AnyPublisher<Bool, any Error> {
        return repository.addFavorite(id, name, image, genres, released, rating)
    }

    func removeFavorite(gameId: Int) -> AnyPublisher<Bool, any Error> {
        return repository.removeFavorite(gameId: gameId)
    }
}
