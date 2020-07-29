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
    case misc = "thoughts"
    case memories = "memories"
    case work = "work"
    case tasks = "tasks"
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
            Category(featuredImage: UIImage(named: "memories")!, monologueCategory: .memories),
            Category(featuredImage: UIImage(named: "thoughts")!, monologueCategory: .misc),
            Category(featuredImage: UIImage(named: "work")!,monologueCategory: .work),
            Category(featuredImage: UIImage(named: "tasks")!, monologueCategory: .tasks)
            // TODO:  ADD OTHER CATEGORIES AND PICTURES
        ]
    }
}
