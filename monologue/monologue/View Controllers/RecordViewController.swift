//
//  RecordViewController.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit
import Speech

class RecordViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: - OUTLETS
    @IBOutlet var chooseCategory: UITextField!
    @IBOutlet var textField: UITextField!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var textView: UITextView!
    
    // MARK: - PROPERTIES
    let tableView = UITableView()
    var monologueURL: URL?
    var selectedButton: String?
    var monogolueCategory = [MonologueCategory]()
    var monologueController: MonologueController?
    var categories = MonologueCategory.allCases
    
    // AUDIO PROPERTIES
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        
        let flexspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexspace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        textField.inputAccessoryView = toolbar
        chooseCategory.inputAccessoryView = toolbar
        textView.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        createPickerView()
        dismissPickerView()
        updateViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        textView.delegate = self
        textField.delegate = self
        chooseCategory.delegate = self
        
        textField.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // MARK: - ACTIONS
    // Save Button Tapped
    @IBAction func saveMonologue(_ sender: Any) {
        guard
            let title = textField.text, !title.isEmpty,
            let text = textView.text,
            let monologueURL = monologueURL,
            let chooseCategory = chooseCategory.text,
            let category = MonologueCategory(rawValue: chooseCategory) else {
                missingPropertiesAlert()
                return
        }
        monologueController?.createMonologue(title: title, text: text, category: category, monologueURL: monologueURL)
        navigationController?.popViewController(animated: true)
    }
    
    // Record Button Tapped
    @IBAction func recordButtonTapped(_ sender: Any) {
        recordButton.isSelected.toggle()
        
        if recordButton.isSelected {
            requestAuthorization()
            textView.text = ""
            textView.isEditable = false
        } else {
            stopSpeechRecognition()
            textView.isEditable = true
            
            if textView.text.isEmpty {
                textView.text = ""
                textView.textAlignment = .natural
                textView.isEditable = false
                textView.isSelectable = false
            }
        }
    }
    
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            if status == .authorized {
                self.recordAndTranscribe()
            }
        }
    }
    
    private func recordAndTranscribe() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let monologueURL = createNewRecordingURL()
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            NSLog("Error grabbing voice input: \(error)")
        }
        guard let request = recognitionRequest,
            let speechRecognizer = speechRecognizer,
            speechRecognizer.isAvailable else { return }
        
        recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let monoText = result.bestTranscription.formattedString
                self.textView.text = monoText
                self.monologueURL = monologueURL
            } else if let error = error {
                NSLog("Error recognizing speech: \(error)")
            }
        })
    }
    
    private func stopSpeechRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    private func createNewRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        return file
    }
    
    private func updateViews() {
        textView.text = ""
    }
    
    private func missingPropertiesAlert() {
        guard
            let title = textField.text,
            let category = chooseCategory.text,
            let speechToText = textView.text else { return }
        
        if title.isEmpty && category.isEmpty {
            let alert = UIAlertController(title: "Missing Title & Category", message: "Add a title and category so this can be saved.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if title.isEmpty {
            let alert = UIAlertController(title: "Missing Title", message: "Please add a title to save this!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if category.isEmpty {
            let alert = UIAlertController(title: "Missing Category", message: "Use the drop down menu to easily categorize!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if speechToText.isEmpty || speechToText == "Just waiting on you...." {
            let alert = UIAlertController(title: "Missing Monologue", message: "Speak on it, I'm ready for you", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true) {
                if self.textView.text.isEmpty {
                    self.textView.text = "Please speak to me"
                }
            }
        }
    }
}

// MARK: - EXTENSION
extension RecordViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
        }
    }
}


// MARK: - EXTENSION
extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) 
        cell.textLabel?.text = monogolueCategory[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monogolueCategory.count
    }
}

// MARK: - PICKER VIEW EXTENSTION
extension RecordViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        selectedButton = categories[row].rawValue // selected item
        chooseCategory.text = selectedButton
    }
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = categories[row].rawValue
        let myCategory = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 17.0)!,NSAttributedString.Key.foregroundColor:UIColor.orange])
        return myCategory
    }
    
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           chooseCategory.inputView = pickerView
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
        button.tintColor = .orange
        toolBar.barTintColor = .lightGray
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        chooseCategory.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
}
