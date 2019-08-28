//
//  EventTableViewCell.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var eventTitleLabel: UILabel! {
        didSet {
            self.eventTitleLabel.textColor = UIColor.greenLogo
        }
    }
    
    @IBOutlet weak var dateEventLabel: UILabel! {
        didSet {
            self.dateEventLabel.textColor = UIColor.greenLogo
        }
    }
    
    @IBOutlet weak var timeEventLabel: UILabel! {
        didSet {
            self.timeEventLabel.textColor = UIColor.greenLogo
        }
    }
}
