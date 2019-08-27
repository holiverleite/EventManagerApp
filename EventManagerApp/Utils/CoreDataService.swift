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
    
    static func save(event: Event) {
        if let context = self.getContext() {
            let entity = NSEntityDescription.entity(forEntityName: "EventCoreData", in: context)!
            
            let eventObjectCoreData = NSManagedObject(entity: entity, insertInto: context)
            eventObjectCoreData.setValue(event.id, forKey: "id")
            eventObjectCoreData.setValue(event.title, forKey: "title")
            eventObjectCoreData.setValue(event.date, forKey: "date")
            eventObjectCoreData.setValue(event.time, forKey: "time")
            eventObjectCoreData.setValue(event.eventDescription, forKey: "eventDescription")

            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
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
    
    static func updateData(object: Event) {
        if let context = self.getContext() {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "EventCoreData")
            fetchRequest.predicate = NSPredicate(format: "id = %@", object.id)
            do {
                let event = try context.fetch(fetchRequest)
                if let objectUpdate = event[0] as? NSManagedObject {
                    objectUpdate.setValue(object.id, forKey: "id")
                    objectUpdate.setValue(object.title, forKey: "title")
                    objectUpdate.setValue(object.date, forKey: "date")
                    objectUpdate.setValue(object.time, forKey: "time")
                    objectUpdate.setValue(object.eventDescription, forKey: "eventDescription")
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print("Could no update. \(error), \(error.userInfo)")
                    }
                }
            } catch let error as NSError {
                print("Could no update. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func entityIsEmpty() -> Bool {
        if let context = self.getContext() {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EventCoreData")
            
            do {
                let events = try context.fetch(fetchRequest)
                if events.count > 0 {
                    return false
                } else {
                    return true
                }
            } catch let error as NSError {
                return true
            }
        }
        return true
    }
}
