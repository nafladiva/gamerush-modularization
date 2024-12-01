//
//  GameInteractor.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Combine
import Foundation

class FavoriteInteractor: FavoriteUseCase {

    private let repository: FavoriteRepositoryProtocol

    init(repository: FavoriteRepositoryProtocol) {
        self.repository = repository
    }

    func getFavorites() -> AnyPublisher<[FavoriteEntity], any Error> {
        return repository.getFavorites()
    }
}
