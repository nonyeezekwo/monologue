//
//  Category.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import UIKit

enum MonologueCategory: String, CaseIterable {
    case misc = "Thoughts"
    case memories = "Memories"
    case work = "Work"
    case tasks = "Tasks"
    case vacation = "Vacation"
    case knowledge = "Knowledge"
}

class Category {
    
    var monologueCategory: MonologueCategory?
    var featuredImage: UIImage
    
    init(featuredImage: UIImage, monologueCategory: MonologueCategory) {
        self.featuredImage = featuredImage
        self.monologueCategory = monologueCategory
    }
    static func fetchCategories() -> [Category] {
        return [
            Category(featuredImage: UIImage(named: "thoughts")!, monologueCategory: .misc),
            Category(featuredImage: UIImage(named: "tasks")!, monologueCategory: .tasks),
            Category(featuredImage: UIImage(named: "work")!,monologueCategory: .work),
            Category(featuredImage: UIImage(named: "memories")!, monologueCategory: .memories),
            Category(featuredImage: UIImage(named: "vacation")!,monologueCategory: .vacation),
            Category(featuredImage: UIImage(named: "knowledge")!, monologueCategory: .knowledge)
        ]
    }
}
