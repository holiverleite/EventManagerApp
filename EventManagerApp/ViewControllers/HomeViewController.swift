//
//  HomeViewController.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit
import CoreData
import Firebase

struct Event {
    var id: String = ""
    var title: String = ""
    var date: String = ""
    var time: String = ""
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
    
    @IBOutlet weak var infoButton: UIBarButtonItem! {
        didSet {
            self.infoButton.target = self
            self.infoButton.action = #selector(self.showInfoApp)
            self.infoButton.tintColor = UIColor.greenLogo
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
    @IBOutlet weak var emptyStateMessage: UILabel! {
        didSet {
            self.emptyStateMessage.text = StringConstants.EmptyEventsMessage
            self.emptyStateMessage.textColor = UIColor.greenLogo
        }
    }
    
    // MARK: - Variables
    private var events: [NSManagedObject] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Try to load all values from Firebase if local database is empty
        if CoreDataService.entityIsEmpty() {
            Database.database().reference().queryOrdered(byChild: StringConstants.mainNode).observeSingleEvent(of: .value) { (snapshot) in
                guard let dict = snapshot.value as? [String: Any] else {
                    return
                }
                
                if let elements = dict[StringConstants.mainNode] as? [String:Any] {
                    // Get each Event from Firebase and save in the local database
                    for (_,value) in elements {
                        if let eventDict = value as? [String:String] {
                            guard let id = eventDict[StringConstants.Id],
                                let title = eventDict[StringConstants.Title],
                                let date = eventDict[StringConstants.Date],
                                let time = eventDict[StringConstants.Time],
                                let descrip = eventDict[StringConstants.Description] else {
                                    return
                            }
                            
                            var event = Event(title, date, time, descrip)
                            event.id = id
                            // Save Event in the Coredata
                            CoreDataService.save(event: event)
                        }
                    }
                    self.reloadTableViewContent()
                }
            }
        } else {
            self.reloadTableViewContent()
        }
        
        let backButton = UIBarButtonItem()
        backButton.tintColor = UIColor.greenLogo
        self.navigationItem.backBarButtonItem = backButton
        self.title = StringConstants.MyEventsMessage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadTableViewContent()
    }
    
    // MARK: - Methods
    @objc private func createEventAction() {
        if let eventCreationViewController = StoryboardUtils.getInitialViewController(storyboardEnum: .EventCreation) as? EventCreationViewController {
            self.navigationController?.pushViewController(eventCreationViewController, animated: true)
        }
    }
    
    @objc private func showInfoApp() {
        if let viewController = StoryboardUtils.getInitialViewController(storyboardEnum: .InfoApp) as? InfoAboutAppViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func verifyHomeViewState() {
        (self.events.count > 0) ? (self.emptyStateView.isHidden = true) : (self.emptyStateView.isHidden = false)
    }
    
    private func reloadTableViewContent() {
        self.events.removeAll()
        self.events = CoreDataService.fetchEvents()
        self.verifyHomeViewState()
        self.tableView.reloadData()
    }
}

// MARK: - Delegates
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = self.events[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventTableViewCell.self), for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        cell.eventTitleLabel.text = event.value(forKey: StringConstants.Title) as? String
        cell.dateEventLabel.text = event.value(forKey: StringConstants.Date) as? String
        cell.timeEventLabel.text = event.value(forKey: StringConstants.Time) as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = self.events[indexPath.row]
        
        if let detailEvent = StoryboardUtils.getInitialViewController(storyboardEnum: .Detail) as? DetailViewController {
            guard let title = event.value(forKey: StringConstants.Title) as? String,
                let id = event.value(forKey: StringConstants.Id) as? String,
                let date = event.value(forKey: StringConstants.Date) as? String,
                let time = event.value(forKey: StringConstants.Time) as? String,
                let eventDescription = event.value(forKey: StringConstants.Description) as? String else {
                    return
            }
            
            var eventObject = Event(title, date, time, eventDescription)
            eventObject.id = id
            detailEvent.eventDetail = eventObject
            self.navigationController?.pushViewController(detailEvent, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Delete Event when swipe cell to left
        if editingStyle == .delete {
            let event = self.events[indexPath.row]
            if let eventId = event.value(forKey: StringConstants.Id) as? String {
                Database.database().reference().child(StringConstants.mainNode).child(eventId).removeValue { error, _ in
                    CoreDataService.deleteFromDataBase(object: event)
                    
                    self.events.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .bottom)
                    self.verifyHomeViewState()
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}

