//
//  MonologueController.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import CoreData

class MonologueController {
    
    var monologues: [Monologue] = []
    static let shared = MonologueController()
    var monologueRepresentation: [MonologueRepresentation] = []
    
    func createMonologue(title: String,
                         text: String,
                         category: MonologueCategory,
                         monologueURL: URL) {
        let monologue = Monologue(monologueTitle: title, text: text, category: category, monologueURL: monologueURL)
        
        monologues.append(monologue)
        CoreDataStack.shared.save()
    }
    
    func updateMonologue(_ monologue: Monologue,
                         title: String,
                         text: String,
                         category: MonologueCategory,
                         monologueURL: URL) {
        monologue.monologueTitle = title
        monologue.text = text
        monologue.category = category.rawValue

        CoreDataStack.shared.save()
    }
    
//    func updateMonologue(monologue: Monologue, with representations: MonologueRepresentation) {
//
//        monologue.monologueTitle = representations.monologueTitle
//        monologue.category = representations.category
//        monologue.text = representations.text
//
//        CoreDataStack.shared.save()
//
//    }
    
    func deleteMonologue(_ monologue: Monologue) {
        CoreDataStack.shared.mainContext.delete(monologue)
        CoreDataStack.shared.save()
    }
}
