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

class FavoriteRepository: FavoriteRepositoryProtocol {

    private let dataSource: FavoriteDataSourceProtocol

    init(dataSource: FavoriteDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func getFavorites() -> AnyPublisher<[FavoriteEntity], any Error> {
        return dataSource.getFavorites()
            .eraseToAnyPublisher()
    }
}
