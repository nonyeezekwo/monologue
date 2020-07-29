//
//  DetailsViewController.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var monologueTextView: UITextView!
    
    // MARK: - PROPERTIES
    
    var monologue: Monologue?
    var monologueController: MonologueController?
    var categories = MonologueCategory.allCases
    var wasEdited = false

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        titleTextField.delegate = self
        categoryTextField.delegate = self
        monologueTextView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
//        navigationController?.setNavigationBarHidden(false, animated: false)
        if wasEdited {
            guard let monologueTitle = titleTextField.text,
                !monologueTitle.isEmpty,
                let monologueText = monologueTextView.text,
                !monologueText.isEmpty,
                let category = categoryTextField.text,
                !category.isEmpty,
                let monologue = monologue else { return }

            let title = titleTextField.text!
            monologue.monologueTitle = monologueTitle
            let text = monologueTextView.text
            monologue.text = text
            let categor = categoryTextField.text
            monologue.category = categor
            
//            monologueController?.updateMonologue(with: monologue)
            do {
                try CoreDataStack.shared.save()
            } catch {
                NSLog("Error saving managed object context (during note edit): \(error)")
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        titleTextField.isUserInteractionEnabled = editing
        monologueTextView.isUserInteractionEnabled = editing
        categoryTextField.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }

    private func updateViews() {
        guard let monologue = monologue else { return }
        
        titleTextField.text = monologue.monologueTitle
        titleTextField.isUserInteractionEnabled = isEditing
        
        categoryTextField.text = monologue.category
        categoryTextField.isUserInteractionEnabled = isEditing
        
        monologueTextView.text = monologue.text
        monologueTextView.isUserInteractionEnabled = isEditing
    }
    
    // MARK: - ACTIONS
//     SAVE BUTTON - TODO: CHANGE FROM SAVE TO EDIT WHEN EDITING
    @IBAction func saveNewMonologue(_ sender: Any) {
        guard
            let title = titleTextField.text, !title.isEmpty,
            let text = monologueTextView.text,
            let urlString = monologue?.monologueURL,
            let monologueURL = URL(string: urlString),
            let categoryText = categoryTextField.text,
            let category = MonologueCategory(rawValue: categoryText),
            let monologue = monologue
             else { return }

        monologueController?.updateMonologue(monologue, title: title, text: text, category: category, monologueURL: monologueURL)
        navigationController?.popToRootViewController(animated: true)
    }
    // BACK BUTTON
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
