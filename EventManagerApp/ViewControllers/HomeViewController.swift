//
//  HomeViewController.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit

struct Event {
    var title: String?
    var date: String?
    var time: String?
    var eventDescription: String?
    
    init(_ title: String, _ date: String, _ time: String, _ description: String) {
        self.title = title
        self.date = date
        self.time = time
        self.eventDescription = description
    }
}

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var createEventButton: UIBarButtonItem! {
        didSet {
            self.createEventButton.target = self
            self.createEventButton.action = #selector(self.createEventAction)
            
            self.createEventButton.tintColor = UIColor.greenLogo
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.register(EventTableViewCell.self, forCellReuseIdentifier: String(describing: EventTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: EventTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: EventTableViewCell.self))
        }
    }
    
    @IBOutlet weak var emptyStateView: UIView!
    
    // MARK: - Variables
    var events: [Event] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // *** Just to testing populate of tableview ***
        for _ in (1...15) {
            let event = Event("Aniversario", "15/12/2019", "19:00", "São Carlos - Casa do Haroldo")
            self.events.append(event)
        }
        (self.events.count > 0) ? (self.emptyStateView.isHidden = true) : (self.emptyStateView.isHidden = false)
        // **************************************
        
        self.title = "Meus Eventos"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update tableView always when appear
    }
    
    // MARK: - Methods
    @objc private func createEventAction() {
        if let eventCreationViewController = StoryboardUtils.getInitialViewController(storyboardEnum: .EventCreation) as? EventCreationViewController {
            self.navigationController?.pushViewController(eventCreationViewController, animated: true)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = self.events[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventTableViewCell.self), for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        cell.eventTitleLabel.text = event.title
        cell.dateEventLabel.text = event.date
        cell.timeEventLabel.text = event.time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = self.events[indexPath.row]
        
        if let detailEvent = StoryboardUtils.getInitialViewController(storyboardEnum: .Detail) as? DetailViewController {
            detailEvent.eventDetail = event
            
            self.navigationController?.pushViewController(detailEvent, animated: true)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}

