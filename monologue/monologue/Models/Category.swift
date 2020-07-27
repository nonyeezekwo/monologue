//
//  Category.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var monologueCategory: MonologueCategory?
    var featuredImage: UIImage
    
    init(featuredImage: UIImage) {
        self.featuredImage = featuredImage
    }

 static func fetchCategories() -> [Category] {
    return [
    Category(featuredImage: UIImage(named: "memories")!),
    Category(featuredImage: UIImage(named: "thoughts")!)
    ]
    }
}
