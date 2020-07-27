//
//  Monologue+Convenience.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import CoreData

extension Monologue {
    @discardableResult convenience init(monologueTitle: String,
                                        text: String,
                                        category: MonologueCategory,
                                        monologueURL: URL,
                                        dateCreated: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.monologueTitle = monologueTitle
        self.text = text
        self.category = category.rawValue
        self.monologueURL = "\(monologueURL)"
        self.dateCreated = dateCreated
    }
}
