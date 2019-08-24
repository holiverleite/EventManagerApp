//
//  DetailViewController.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var editEventButton: UIBarButtonItem! {
        didSet {
            self.editEventButton.target = self
            self.editEventButton.action = #selector(self.editEventAction)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detalhes do Evento"
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    @objc private func editEventAction() {
        if let eventCreationViewController = StoryboardUtils.getInitialViewController(storyboardEnum: .EventCreation) as? EventCreationViewController {
            self.navigationController?.pushViewController(eventCreationViewController, animated: true)
        }
    }
}
