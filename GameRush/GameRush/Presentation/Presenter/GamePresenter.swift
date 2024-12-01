//
//  GamePresenter.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Combine
import Foundation

class GamePresenter: GamePresenterProtocol {

    private let gameUseCase: GameUseCase
    
    init(useCase: GameUseCase) {
        self.gameUseCase = useCase
    }
    
    func getGamesV2() -> AnyPublisher<[GameEntity], Error> {
        return gameUseCase.getGamesV2()
    }
    
    func getGameDetailV2(gameId: Int) -> AnyPublisher<GameDetailEntity, Error> {
        return gameUseCase.getGameDetailV2(gameId: gameId)
    }
    
    func getFavorites() -> AnyPublisher<[FavoriteEntity], any Error> {
        return gameUseCase.getFavorites()
    }

    func checkFavoriteStatus(gameId: Int) -> AnyPublisher<Bool, any Error> {
        return gameUseCase.checkFavoriteStatus(gameId: gameId)
    }
    
    func addFavorite(_ id: Int, _ name: String, _ image: Data, _ genres: String, _ released: String, _ rating: Double) -> AnyPublisher<Bool, any Error> {
        return gameUseCase.addFavorite(id, name, image, genres, released, rating)
    }
    
    func removeFavorite(gameId: Int) -> AnyPublisher<Bool, any Error> {
        return gameUseCase.removeFavorite(gameId: gameId)
    }
}
