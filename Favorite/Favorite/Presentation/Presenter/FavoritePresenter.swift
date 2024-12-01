//
//  FavoritePresenter.swift
//  Favorite
//
//  Created by Nafla Diva Syafia on 01/12/24.
//

import Combine
import Foundation

class FavoritePresenter: FavoritePresenterProtocol {

    private let useCase: FavoriteUseCase
    
    init(useCase: FavoriteUseCase) {
        self.useCase = useCase
    }
    
    func getFavorites() -> AnyPublisher<[FavoriteEntity], any Error> {
        return useCase.getFavorites()
    }
}

