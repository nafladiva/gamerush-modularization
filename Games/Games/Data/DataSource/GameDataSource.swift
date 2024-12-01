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

class GameDataSource: GameDataSourceProtocol {
    
    private let coreDataStack: CoreDataStack
    private var cancellables = Set<AnyCancellable>()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func getGames() -> AnyPublisher<GamesResponses, Error> {
        var components = URLComponents(string: "https://api.rawg.io/api/games")!
        components.queryItems = [
            URLQueryItem(name: "key", value: GRSecret.apiKey)
        ]
        let request = URLRequest(url: components.url!)
        
        return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                        throw GameRushError.connectionFailed
                    }
                    return data
                }
                .decode(type: GamesResponses.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }
    
    func getGameDetail(gameId: Int) -> AnyPublisher<GameDetailResponse, Error> {
        var components = URLComponents(string: "https://api.rawg.io/api/games/\(gameId)")!
        components.queryItems = [
            URLQueryItem(name: "key", value: GRSecret.apiKey)
        ]
        let request = URLRequest(url: components.url!)
        
        return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                        throw GameRushError.connectionFailed
                    }
                    return data
                }
                .decode(type: GameDetailResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }

    func checkFavoriteStatus(gameId: Int) -> AnyPublisher<Bool, any Error> {
        let taskContext = coreDataStack.newTaskContext()
        
        return Future { promise in
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id == \(gameId)")
                do {
                    let result = try taskContext.fetch(fetchRequest).first
                    if result != nil {
                        promise(.success(false))
                    } else {
                        promise(.success(true))
                    }
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addFavorite(
        _ id: Int,
        _ name: String,
        _ image: Data,
        _ genres: String,
        _ released: String,
        _ rating: Double
    ) -> AnyPublisher<Bool, any Error> {
        let taskContext = coreDataStack.newTaskContext()

        return Future { promise in
            taskContext.performAndWait {
                guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: taskContext) else {
                    promise(.failure(NSError(domain: "CoreData", code: 1, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])))
                    return
                }
                let favorite = NSManagedObject(entity: entity, insertInto: taskContext)
                
                favorite.setValue(id, forKey: "id")
                favorite.setValue(name, forKey: "name")
                favorite.setValue(image, forKey: "image")
                favorite.setValue(genres, forKey: "genres")
                favorite.setValue(released, forKey: "released")
                favorite.setValue(rating, forKey: "rating")
                
                do {
                    try taskContext.save()
                    try taskContext.parent?.save()
                    promise(.success(true))
                } catch let error as NSError {
                    print("Failed to add. \(error), \(error.userInfo)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func removeFavorite(gameId: Int) -> AnyPublisher<Bool, any Error> {
        let taskContext = coreDataStack.newTaskContext()
        
        return Future { promise in
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id == \(gameId)")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                batchDeleteRequest.resultType = .resultTypeCount
                if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                    if batchDeleteResult.result != nil {
                        promise(.success(true))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
