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
        }
    }
    
    @IBOutlet weak var timeTextField: UITextField! {
        didSet {
            self.timeTextField.delegate = self
        }
    }
    
    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet {
            self.descriptionTextField.delegate = self
        }
    }
    
    @IBOutlet weak var createEventButton: UIButton! {
        didSet {
            self.createEventButton.addTarget(self, action: #selector(createEventAction), for: .touchUpInside)
        }
    }
    
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
    
}

extension EventCreationViewController: UITextFieldDelegate {
    
}
