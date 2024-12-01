//
//  Injection.swift
//  GameRush
//
//  Created by Nafla Diva Syafia on 23/11/24.
//

import Foundation

final class Injection: NSObject {
    
    private func provideCoreData() -> CoreDataStack {
        let coreDataStack = CoreDataStack(modelName: "GRCoreData")
        coreDataStack.loadPersistentStores { error in
            if let error = error {
                print("Failed to load persistent stores: \(error)")
            } else {
                print("Persistent stores loaded successfully")
            }
        }
        return coreDataStack
    }
 
    private func provideDataSource() -> GameDataSourceProtocol {
        let coreDataStack = provideCoreData()
        return GameDataSource(coreDataStack: coreDataStack)
    }
 
    private func provideRepository() -> GameRepositoryProtocol {
        let gameDataSource = provideDataSource()
        return GameRepository(dataSource: gameDataSource)
    }
 
    func provideUseCase() -> GameUseCase {
        let gameRepository = provideRepository()
        return GameInteractor(repository: gameRepository)
    }
 
}
