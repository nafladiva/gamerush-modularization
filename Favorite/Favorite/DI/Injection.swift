//
//  Injection.swift
//  Favorite
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
                print("[Favorite] Failed to load persistent stores: \(error)")
            } else {
                print("Persistent stores loaded successfully")
            }
        }
        return coreDataStack
    }
 
    private func provideDataSource() -> FavoriteDataSourceProtocol {
        let coreDataStack = provideCoreData()
        return FavoriteDataSource(coreDataStack: coreDataStack)
    }
 
    private func provideRepository() -> FavoriteRepositoryProtocol {
        let dataSource = provideDataSource()
        return FavoriteRepository(dataSource: dataSource)
    }
 
    func provideUseCase() -> FavoriteUseCase {
        let repository = provideRepository()
        return FavoriteInteractor(repository: repository)
    }
 
}
