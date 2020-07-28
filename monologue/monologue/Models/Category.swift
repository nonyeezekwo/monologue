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
    
    init(featuredImage: UIImage) {
        self.featuredImage = featuredImage
        //        self.monologueCategory = monologueCategory
    }
    #warning("IS THIS WHY IT KEEPS CRASHING ON LINE 48 OF THE COLLECTIONVIEWCELL?")
    static func fetchCategories() -> [Category] {
        return [
            Category(featuredImage: UIImage(named: "memories")!),
            Category(featuredImage: UIImage(named: "thoughts")!),
            Category(featuredImage: UIImage(named: "work")!),
            Category(featuredImage: UIImage(named: "tasks")!)
            // TODO:  ADD OTHER CATEGORIES AND PICTURES
        ]
    }
}
