//
//  EventCreationViewController.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit

class EventCreationViewController: UIViewController {
    
    // MARK: - IBOutlets
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
        }
    }
    
    // MARK: - Variables
    let picker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        return datePicker
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Criar Evento"
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    @objc func createEventAction() {
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
