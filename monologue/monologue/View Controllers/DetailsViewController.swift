//
//  DetailsViewController.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var monologueTextView: UITextView!
    
    // MARK: - Properties
    
    let monologue: Monologue
    let monologueController: MonologueController
    let dateFormatter: DateFormatter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    init?(coder: NSCoder, monologue: Monologue,
          monologueController: MonologueController,
          dateFormatter: DateFormatter) {
        self.monologue = monologue
        self.monologueController = monologueController
        self.dateFormatter = dateFormatter
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
