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
    @IBOutlet weak var editEventButton: UIButton! {
        didSet {
            self.editEventButton.addTarget(self, action: #selector(editEventAction), for: .touchUpInside)
            self.editEventButton.backgroundColor = UIColor.greenLogo
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Variables
    var eventDetail: Event?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detalhes do Evento"
        
        if let event = self.eventDetail {
            self.titleLabel.text = event.title
            self.dateLabel.text = event.date
            self.timeLabel.text = event.time
            self.descriptionLabel.text = event.eventDescription
        }
    }
    
    // MARK: - Methods
    @objc private func editEventAction() {
        if let eventCreationViewController = StoryboardUtils.getInitialViewController(storyboardEnum: .EventCreation) as? EventCreationViewController {
            eventCreationViewController.isEditingMode = true
            
            if let event = self.eventDetail {
                eventCreationViewController.eventDetail = event
            }
            
            self.navigationController?.pushViewController(eventCreationViewController, animated: true)
        }
    }
}
