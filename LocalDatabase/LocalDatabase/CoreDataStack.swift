//
//  CoreDataStack.swift
//  GameRush
//
//  Created by Nafla Diva Syafia (ID) on 26/11/24.
//

import Foundation
import CoreData

public class CoreDataStack {
    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public init(modelName: String) {
        self.persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    public func loadPersistentStores(completion: @escaping (Error?) -> Void) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    public func newTaskContext() -> NSManagedObjectContext {
        let taskContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        taskContext.parent = context
        return taskContext
    }
}
