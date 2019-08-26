//
//  CoreDataService.swift
//  EventManagerApp
//
//  Created by monitora on 26/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {
    
    //MARK: - Singleton
    static func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    static func save(event: Event) -> NSManagedObject? {
        if let context = self.getContext() {
            let entity = NSEntityDescription.entity(forEntityName: "EventCoreData", in: context)!
            
            let eventObjectCoreData = NSManagedObject(entity: entity, insertInto: context)
            eventObjectCoreData.setValue(event.title, forKey: "title")
            eventObjectCoreData.setValue(event.date, forKey: "date")
            eventObjectCoreData.setValue(event.time, forKey: "time")
            eventObjectCoreData.setValue(event.eventDescription, forKey: "eventDescription")

            do {
                try context.save()
                return eventObjectCoreData
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        return nil
    }
    
    static func fetchEvents() -> [NSManagedObject] {
        if let context = self.getContext() {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EventCoreData")
            
            do {
                let events = try context.fetch(fetchRequest)
                return events
            } catch let error as NSError {
                print("Could no fetch. \(error), \(error.userInfo)")
            }
        }
        
        return []
    }
    
    static func deleteFromDataBase(object: NSManagedObject) {
        if let context = self.getContext() {
            do {
                context.delete(object)
                try context.save()
            } catch let error as NSError {
                print("Could no delete. \(error), \(error.userInfo)")
            }
        }
    }
}
