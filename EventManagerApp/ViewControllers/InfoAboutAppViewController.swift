//
//  InfoAboutAppViewController.swift
//  EventManagerApp
//
//  Created by monitora on 28/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit

class InfoAboutAppViewController: UIViewController {

    @IBOutlet weak var nameAppLabel: UILabel!
    @IBOutlet weak var logoAppImageView: UIImageView!
    @IBOutlet weak var developedByLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var aboutProjectLAbel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = StringConstants.AboutMessage
    }
}
