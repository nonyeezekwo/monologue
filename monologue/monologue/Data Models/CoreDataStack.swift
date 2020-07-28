//
//  CoreDataStack.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private init() {}
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Monologue")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading persistent stores: \(error)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving context \(error)")
                context.reset()
            }
        }
    }
}
