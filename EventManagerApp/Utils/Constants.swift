//
//  Constants.swift
//  EventManagerApp
//
//  Created by leite on 24/08/19.
//  Copyright © 2019 holiverleite. All rights reserved.
//

import UIKit

struct StringConstants {
    // CoreData Attributes
    static let Id = "id"
    static let Title = "title"
    static let Date = "date"
    static let Time = "time"
    static let Description = "eventDescription"
    
    // CoreData Entity
    static let EntityName = "EventCoreData"
    
    // Node RealtimeDatabase
    static let mainNode = "events"
    
    // Messages
    static let EmptyEventsMessage = "Você não tem eventos cadastrados. Clique no '+' para criar um novo evento."
    static let MyEventsMessage = "Meus Eventos"
    static let EditEventMessage = "Editar Evento"
    static let CreateEventMessage = "Criar Evento"
    static let EventDetailMessage = "Detalhes do Evento"
    static let WarningTitle = "Atenção"
    static let WarningMessage = "Todos os campos são obrigatórios!"
    
    // Buttons
    static let SaveButton = "Salvar"
    static let CreateButton = "Criar"
    static let OkButton = "Ok"
}

struct ImageConstants {
    static let BackButtonIcon = UIImage(named: "back_button_icon")
}

extension UIColor {
    public static let greenLogo = UIColor(red: 103/255, green: 166/255, blue: 175/255, alpha: 1)
    
    //MARK: - Convert HEX to RGB
    convenience init(hex: String, alpha: CGFloat) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
}
