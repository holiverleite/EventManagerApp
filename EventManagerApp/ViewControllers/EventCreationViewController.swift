//
//  EventCreationViewController.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit

protocol EventCreationDelegate {
    func eventCreationData(eventData : Event)
}

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
        }
    }
    
    @IBOutlet weak var dateTextField: UITextField! {
        didSet {
            self.dateTextField.delegate = self
            
            self.picker.datePickerMode = .date
            self.picker.addTarget(self, action: #selector(pickerValueChanged), for: UIControl.Event.valueChanged)
            self.dateTextField.inputView = self.picker
        }
    }
    
    @IBOutlet weak var timeTextField: UITextField! {
        didSet {
            self.timeTextField.delegate = self
            
            self.picker.datePickerMode = .time
            self.picker.addTarget(self, action: #selector(pickerValueChanged), for: UIControl.Event.valueChanged)
            self.timeTextField.inputView = self.picker
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var createEventButton: UIButton! {
        didSet {
            self.createEventButton.addTarget(self, action: #selector(createEventAction), for: .touchUpInside)
            self.createEventButton.backgroundColor = UIColor.greenLogo
        }
    }
    
    // MARK: - Variables
    var delegate: EventCreationDelegate?
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
        if let title = self.nameTextField.text, let date = self.dateTextField.text, let time = self.timeTextField.text, let eventDescription = self.descriptionTextView.text {
            let event = Event(title, date, time, eventDescription)
            
            self.delegate?.eventCreationData(eventData: event)
            self.navigationController?.popViewController(animated: true)
        }
        // Implement to send data to Firebase;
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
