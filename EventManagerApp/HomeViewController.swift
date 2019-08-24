//
//  HomeViewController.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var createEventButton: UIBarButtonItem! {
        didSet {
            self.createEventButton.target = self
            self.createEventButton.action = #selector(self.createEventAction)
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Meus Eventos"
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    @objc private func createEventAction() {
        if let eventCreationViewController = StoryboardUtils.getInitialViewController(storyboardEnum: .EventCreation) as? EventCreationViewController {
            self.navigationController?.pushViewController(eventCreationViewController, animated: true)
        }
    }
}

