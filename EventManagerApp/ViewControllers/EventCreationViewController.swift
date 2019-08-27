//
//  EventCreationViewController.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EventCreationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var mainView: UIView! {
        didSet {
            self.mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            self.nameTextField.delegate = self
            self.nameTextField.borderStyle = .roundedRect
            self.nameTextField.layer.borderColor = UIColor.greenLogo.cgColor
        }
    }
    
    @IBOutlet weak var dateTextField: UITextField! {
        didSet {
            self.dateTextField.delegate = self
            
            self.picker.datePickerMode = .date
            self.picker.addTarget(self, action: #selector(pickerValueChanged), for: UIControl.Event.valueChanged)
            self.dateTextField.inputView = self.picker
            self.dateTextField.borderStyle = .roundedRect
            self.dateTextField.layer.borderColor = UIColor.greenLogo.cgColor
        }
    }
    
    @IBOutlet weak var timeTextField: UITextField! {
        didSet {
            self.timeTextField.delegate = self
            
            self.picker.datePickerMode = .time
            self.picker.addTarget(self, action: #selector(pickerValueChanged), for: UIControl.Event.valueChanged)
            self.timeTextField.inputView = self.picker
            self.timeTextField.borderStyle = .roundedRect
            self.timeTextField.layer.borderColor = UIColor.greenLogo.cgColor
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            self.descriptionTextView.layer.borderColor = UIColor.greenLogo.cgColor
        }
    }
    
    @IBOutlet weak var createEventButton: UIButton! {
        didSet {
            self.createEventButton.addTarget(self, action: #selector(createEventAction), for: .touchUpInside)
            self.createEventButton.backgroundColor = UIColor.greenLogo
        }
    }
    
    // MARK: - Variables
    var eventDetail : Event?
    var isEditingMode = false
    let picker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        return datePicker
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if isEditingMode {
            if let event = self.eventDetail {
                self.nameTextField.text = event.title
                self.dateTextField.text = event.date
                self.timeTextField.text = event.time
                self.descriptionTextView.text = event.eventDescription
            }
            
            self.createEventButton.setTitle("Salvar", for: .normal)
            self.title = "Editar Evento"
        } else {
            self.createEventButton.setTitle("Criar", for: .normal)
            self.title = "Criar Evento"
        }
    }
    
    // MARK: - Methods
    @objc func createEventAction() {
        if let title = self.nameTextField.text, !title.isEmpty,
            let date = self.dateTextField.text, !date.isEmpty,
            let time = self.timeTextField.text, !time.isEmpty,
            let eventDescription = self.descriptionTextView.text, !eventDescription.isEmpty {
            var event = Event(title, date, time, eventDescription)
            
            if let _ = self.eventDetail {
                // Edit Event in Firebase and Coredata
                var dict = [String:Any]()
                dict["id"] = self.eventDetail?.id
                dict["title"] = event.title
                dict["time"] = event.time
                dict["date"] = event.date
                dict["eventDescription"] = event.eventDescription
                
                if let eventId = self.eventDetail?.id {
                    Database.database().reference().child("events").child(eventId).setValue(dict)
                    Database.database().reference().child("events").observe(.value) { (snapshot) in
                        event.id = eventId
                        CoreDataService.updateData(object: event)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } else {
                // Create Event in Firebase and Coredata
                let reference = Database.database().reference()
                    .child("events").childByAutoId()
                
                var dict = [String:Any]()
                dict["id"] = reference.key
                dict["title"] = event.title
                dict["time"] = event.time
                dict["date"] = event.date
                dict["eventDescription"] = event.eventDescription
                
                if let key = reference.key {
                    Database.database().reference().child("events").child(key).setValue(dict)
                }
                
                reference.observeSingleEvent(of: .value) { (snapshot) in
                    guard let dict = snapshot.value as? [String : Any], let id = dict["id"] as? String else {
                        return
                    }
                    // set ID of event and save in the local database
                    event.id = id
                    CoreDataService.save(event: event)
                    // go back to Home after create a Event
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Atenção", message: "Todos os campos são obrigattótios!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func pickerValueChanged(sender: UIDatePicker) {
        if self.dateTextField.isFirstResponder {
            self.setPickerDate()
        } else {
            self.setPickerTime()
        }
    }
    
    private func setPickerDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self.dateTextField.text = dateFormatter.string(from: self.picker.date)
    }
    
    private func setPickerTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        self.timeTextField.text = dateFormatter.string(from: self.picker.date)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension EventCreationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.dateTextField:
            self.picker.datePickerMode = .date
        case self.timeTextField:
            self.picker.datePickerMode = .time
        default:
            break
        }
    }
}
