//
//  DetailsViewController.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: - OUTLETS
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var monologueTextView: UITextView!
    
    // MARK: - PROPERTIES
    var monologue: Monologue?
    var monologueController: MonologueController?
    var categories = MonologueCategory.allCases
    var wasEdited = false
    var editCategoryPicker: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        titleTextField.delegate = self
        categoryTextField.delegate = self
        monologueTextView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
        
        titleTextField.layer.cornerRadius = 10
        monologueTextView.layer.cornerRadius = 10
        createPickerView()
        dismissPickerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
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
    
    @IBAction func pdfButtonTapped(_ sender: Any) {
        guard let monologue = monologue else { return }
        guard let title = monologue.monologueTitle,
            let text = monologue.text else { return }
        
        let monologuePDF = MonologuePDF(title: title, text: text)
        let data = monologuePDF.createMonologue()
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: [])
        present(activityVC, animated: true, completion: nil)
    }
}
// MARK: - PICKER VIEW EXTENSTION
extension DetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].rawValue // dropdown item
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editCategoryPicker = categories[row].rawValue // selected item
        categoryTextField.text = editCategoryPicker
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        categoryTextField.inputView = pickerView
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
    }
    
}
