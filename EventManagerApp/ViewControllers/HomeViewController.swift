//
//  HomeViewController.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit
import CoreData

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
            self.tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var emptyStateView: UIView!
    
    // MARK: - Variables
    var events: [NSManagedObject] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load all events from CoreData
        self.events = CoreDataService.fetchEvents()
        
        let backButton = UIBarButtonItem()
        backButton.tintColor = UIColor.greenLogo
        self.navigationItem.backBarButtonItem = backButton

        self.title = "Meus Eventos"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.verifyHomeViewState()
        self.tableView.reloadData()
        // Update tableView always when appear
    }
    
    // MARK: - Methods
    @objc private func createEventAction() {
        if let eventCreationViewController = StoryboardUtils.getInitialViewController(storyboardEnum: .EventCreation) as? EventCreationViewController {
            eventCreationViewController.delegate = self
            self.navigationController?.pushViewController(eventCreationViewController, animated: true)
        }
    }
    
    func verifyHomeViewState() {
        (self.events.count > 0) ? (self.emptyStateView.isHidden = true) : (self.emptyStateView.isHidden = false)
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
        
        cell.eventTitleLabel.text = event.value(forKey: "title") as? String
        cell.dateEventLabel.text = event.value(forKey: "date") as? String
        cell.timeEventLabel.text = event.value(forKey: "time") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = self.events[indexPath.row]
        
        if let detailEvent = StoryboardUtils.getInitialViewController(storyboardEnum: .Detail) as? DetailViewController {
            guard let title = event.value(forKey: "title") as? String,
                let date = event.value(forKey: "date") as? String,
                let time = event.value(forKey: "time") as? String,
                let eventDescription = event.value(forKey: "eventDescription") as? String else {
                    return
            }
            
            let eventObject = Event(title, date, time, eventDescription)
            detailEvent.eventDetail = eventObject
            self.navigationController?.pushViewController(detailEvent, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = self.events[indexPath.row]
            CoreDataService.deleteFromDataBase(object: event)
            
            self.events.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .bottom)
            
            self.verifyHomeViewState()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}

extension HomeViewController: EventCreationDelegate {
    func eventCreationData(eventData: Event) {
        self.events = CoreDataService.fetchEvents()
        self.tableView.reloadData()
    }
}

