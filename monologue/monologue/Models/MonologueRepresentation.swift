//
//  MonologueRepresentation.swift
//  monologue
//
//  Created by Nonye on 7/29/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import CoreData

struct MonologueRepresentation: Codable {
    var monologueTitle: String?
    var category: String?
    var text: String?
    var monologueURL: String?
    var dateCreated: Date?
}
