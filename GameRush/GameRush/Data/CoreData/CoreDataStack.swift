//
//  CoreDataStack.swift
//  GameRush
//
//  Created by Nafla Diva Syafia (ID) on 26/11/24.
//

import Foundation
import CoreData

class CoreDataStack {
    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        self.persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func loadPersistentStores(completion: @escaping (Error?) -> Void) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func newTaskContext() -> NSManagedObjectContext {
        let taskContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        taskContext.parent = context
        return taskContext
    }
}
