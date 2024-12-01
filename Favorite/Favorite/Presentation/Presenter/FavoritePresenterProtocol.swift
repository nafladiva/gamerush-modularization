//
//  FavoritePresenterProtocol.swift
//  Favorite
//
//  Created by Nafla Diva Syafia on 01/12/24.
//

import Combine
import Foundation

protocol FavoritePresenterProtocol {
    func getFavorites() -> AnyPublisher<[FavoriteEntity], Error>
}

