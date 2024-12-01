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
    
    func getGamesV2() -> AnyPublisher<[GameEntity], any Error> {
        return repository.getGamesV2()
    }
    
    func getGameDetailV2(gameId: Int) -> AnyPublisher<GameDetailEntity, any Error> {
        return repository.getGameDetailV2(gameId: gameId)
    }
    
    func getFavorites() -> AnyPublisher<[FavoriteEntity], any Error> {
        return repository.getFavorites()
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
