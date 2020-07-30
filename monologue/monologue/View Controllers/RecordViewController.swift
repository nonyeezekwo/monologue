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
    
    //    let transparentView = UIView()
    let tableView = UITableView()
    var monologueURL: URL?
    var selectedButton = UIButton()
    //    var monologueCategory: MonologueCategory?
    var monogolueCategory = [MonologueCategory]()
    var monologueController: MonologueController?
    var categories = MonologueCategory.allCases
    //    var monologueCategory: MonologueCategory?
    //    var dataSource = [MonologueCategory]()
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        
        let flexspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexspace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        textField.inputAccessoryView = toolbar
        chooseCategory.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        tableView.delegate = self
        tableView.dataSource = self
        textView.delegate = self
        textField.delegate = self
        chooseCategory.delegate = self
        
        textField.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10

        updateViews()
    }
    
    //    func addTransparentView(frames: CGRect) {
    //        let window = UIApplication.shared.keyWindow
    //        transparentView.frame = window?.frame ?? self.view.frame
    //        self.view.addSubview(transparentView)
    //
    //        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
    //        self.view.addSubview(tableView)
    //        tableView.layer.cornerRadius = 5
    //
    //        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
    //
    //        let tappedButton = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
    //        transparentView.addGestureRecognizer(tappedButton)
    //        transparentView.alpha = 0
    //        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: { self.transparentView.alpha = 0.5
    //            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width + 5, height: 200)
    //
    //        }, completion: nil)
    //    }
    //
    //    @objc func removeTransparentView() {
    //        let frames = selectedButton.frame
    //        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: { self.transparentView.alpha = 0
    //                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
    //        }, completion: nil)
    //    }
    
    
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
                textView.text = "👂🏾"
                textView.textAlignment = .center
                textView.isEditable = false
                textView.isSelectable = false
            }
        }
    }
    
    
    //@IBAction func tappedCategory(_ sender: Any) {
    ////    monogolueCategory = [monogolueCategory].self
    ////    selectedButton = chooseCategory
    //    addTransparentView(frames: chooseCategory.frame)
    //
    //    }
    //
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            if status == .authorized {
                self.recordAndTranscribe()
            }
        }
    }
    
    private func recordAndTranscribe() {
        request = SFSpeechAudioBufferRecognitionRequest()
        
        let monologueURL = createNewRecordingURL()
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            NSLog("Error processing speech: \(error)")
        }
        
        guard
            let request = request,
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
        
        request?.endAudio()
        request = nil
        
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
                    self.textView.text = "(Go ahead, I'm listening)"
                }
            }
        }
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
