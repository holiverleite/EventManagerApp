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

    private static var managedContext: NSManagedObjectContext? = nil
    private static var sharedInstance: CoreDataService? = nil
    
    //MARK: - Singleton
    static func getSharedInstance() -> CoreDataService? {
        guard let checkSharedInstance = self.sharedInstance else {
            let newInstance = CoreDataService()
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return nil
            }
            
            self.managedContext = appDelegate.persistentContainer.viewContext
            
            return newInstance
        }
        
        return checkSharedInstance
    }
    
    static func save(taskDescription: String) {
        if let context = self.managedContext {
            
        }
    }
    
    

}
