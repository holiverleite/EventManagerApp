//
//  StoryboardUtils.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import Foundation
import UIKit

class StoryboardUtils {
    public enum Storyboards: String {
        case EventCreation = "EventCreation"
    }
    
    public static func getInitialViewController(storyboardEnum: StoryboardUtils.Storyboards) -> UIViewController {
        let storyboardName = storyboardEnum.rawValue
        
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        if let initialViewController = storyBoard.instantiateInitialViewController() {
            return initialViewController
        } else {
            fatalError("Impossible to instantiate Initial ViewController for storyboard: \(storyboardName)")
        }
    }
}
