//
//  Injection.swift
//  Games
//
//  Created by Nafla Diva Syafia on 01/12/24.
//

import Common
import Foundation

final class Injection: NSObject {
    
    private func provideCoreData() -> CoreDataStack {
        let coreDataStack = CoreDataStack()
        coreDataStack.loadPersistentStores { error in
            if let error = error {
                print("[Games] Failed to load persistent stores: \(error)")
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
        let dataSource = provideDataSource()
        return GameRepository(dataSource: dataSource)
    }
 
    func provideUseCase() -> GameUseCase {
        let repository = provideRepository()
        return GameInteractor(repository: repository)
    }
 
}
