//
//  GameDataSource.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Foundation
import Combine
import Common
import CoreData
import LocalDatabase

class FavoriteDataSource: FavoriteDataSourceProtocol {
    
    private let coreDataStack: CoreDataStack
    private var cancellables = Set<AnyCancellable>()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getFavorites() -> AnyPublisher<[FavoriteEntity], Error> {
        let taskContext = coreDataStack.newTaskContext()
        
        return Future { promise in
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
                do {
                    let result = try taskContext.fetch(fetchRequest)
                    var favorites: [FavoriteEntity] = []
                    for res in result {
                        let favorite = FavoriteEntity(
                            id: res.value(forKeyPath: "id") as? Int16,
                            name: res.value(forKeyPath: "name") as? String,
                            image: res.value(forKeyPath: "image") as? Data,
                            genres: res.value(forKeyPath: "genres") as? String,
                            released: res.value(forKeyPath: "released") as? String,
                            rating: res.value(forKeyPath: "rating") as? Double
                        )
                        favorites.append(favorite)
                    }
                    promise(.success(favorites))
                } catch let error as NSError {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
