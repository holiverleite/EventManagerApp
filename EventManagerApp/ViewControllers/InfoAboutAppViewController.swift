//
//  InfoAboutAppViewController.swift
//  EventManagerApp
//
//  Created by monitora on 28/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit

class InfoAboutAppViewController: UIViewController {

    @IBOutlet weak var nameAppLabel: UILabel! {
        didSet {
            self.nameAppLabel.textColor = UIColor.greenLogo
        }
    }
    
    @IBOutlet weak var logoAppImageView: UIImageView! {
        didSet {
            self.logoAppImageView.image = UIImage(named: "LaunchImage")
        }
    }
    
    @IBOutlet weak var developedByLabel: UILabel! {
        didSet {
            self.developedByLabel.textColor = UIColor.greenLogo
            self.developedByLabel.text = "Desenvolvido por: \n Haroldo Oliveira de Almeida Leite \n holiverleite@gmail.com"
        }
    }
    
    @IBOutlet weak var subjectLabel: UILabel! {
        didSet {
            self.subjectLabel.textColor = UIColor.greenLogo
            self.subjectLabel.text = "TÓPICOS EM DESENVOLVIMENTO DE PROGRAMAS MÓVEIS 2 \n (TDMP3)"
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            self.descriptionLabel.textColor = UIColor.greenLogo
            self.descriptionLabel.text = " Prof. Dr. Fernando Vernal Salina"
        }
    }
    
    @IBOutlet weak var aboutProjectLAbel: UILabel! {
        didSet {
            self.aboutProjectLAbel.textColor = UIColor.greenLogo
            self.aboutProjectLAbel.text = "IFSP - 2019"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = StringConstants.AboutMessage
    }
}
