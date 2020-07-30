//
//  MemoTableViewCell.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var monologue: Monologue?{
        didSet{
            self.updateUI()
        }
    }
    
    var dateFormatter: DateFormatter? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        guard
            let monologue = monologue,
            let date = monologue.dateCreated,
            let dateFormatter = dateFormatter else { return }
        
        let dateString = dateFormatter.string(from: date)
        titleLabel.text = monologue.monologueTitle
        dateLabel.text = dateString.uppercased()
    }
}
