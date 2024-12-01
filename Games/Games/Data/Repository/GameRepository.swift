//
//  GameRepository.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Combine
import CoreData
import Foundation
import UIKit

class GameRepository: GameRepositoryProtocol {

    private let gameDataSource: GameDataSourceProtocol

    init(dataSource: GameDataSourceProtocol) {
        self.gameDataSource = dataSource
    }

    func getGames() -> AnyPublisher<[GameEntity], any Error> {
        return gameDataSource.getGames()
            .tryMap { items in
                try self.listMapper(input: items)
            }
            .eraseToAnyPublisher()
    }

    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailEntity, any Error> {
        return gameDataSource.getGameDetail(gameId: gameId)
            .tryMap { items in
                try self.detailMapper(input: items)
            }
            .eraseToAnyPublisher()
    }

    func checkFavoriteStatus(gameId: Int) -> AnyPublisher<Bool, any Error> {
        return gameDataSource.checkFavoriteStatus(gameId: gameId)
            .eraseToAnyPublisher()
    }

    func addFavorite(_ id: Int, _ name: String, _ image: Data, _ genres: String, _ released: String, _ rating: Double) -> AnyPublisher<Bool, any Error> {
        return gameDataSource.addFavorite(id, name, image, genres, released, rating)
            .eraseToAnyPublisher()
    }

    func removeFavorite(gameId: Int) -> AnyPublisher<Bool, any Error> {
        return gameDataSource.removeFavorite(gameId: gameId)
            .eraseToAnyPublisher()
    }
}

extension GameRepository {
    fileprivate func listMapper(
        input responses: GamesResponses
    ) throws -> [GameEntity] {
        let gameReponses = responses.results
        return try gameReponses.map { result in
            let data = try Data(contentsOf: URL(string: result.backgroundImage)!)
            let image = UIImage(data: data)

            return GameEntity(
                id: result.id,
                name: result.name,
                released: result.released,
                backgroundImage: image,
                rating: result.rating,
                genres: result.genres.map { res in
                    return GenreEntity(id: res.id, name: res.name)
                }
            )
        }
    }

    fileprivate func detailMapper(
        input response: GameDetailResponse
    ) throws -> GameDetailEntity {
        let data = try Data(contentsOf: URL(string: response.backgroundImage)!)
        let image = UIImage(data: data)

        return GameDetailEntity(
            id: response.id,
            name: response.name,
            descriptionRaw: response.descriptionRaw,
            released: response.released,
            backgroundImage: image,
            website: response.website,
            rating: response.rating,
            developers: response.developers.map { res in
                return DeveloperEntity(id: res.id, name: res.name)
            },
            genres: response.genres.map { res in
                return GenreEntity(id: res.id, name: res.name)
            },
            publishers: response.publishers.map { res in
                return PublisherEntity(id: res.id, name: res.name, gamesCount: res.gamesCount, imageBackground: res.imageBackground)
            }
        )
    }
}
