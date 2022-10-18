//
//  CoreDataManager.swift
//  notepad
//
//  Created by Hicret Ay on 18.10.2022.
//

import Foundation
import CoreData

class CoreDataManager{
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    private init( ){
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores{description, error in
            if let error = error{
                fatalError("Unable to initialize core data \(error)")
            }
            
        }
    }
    
}
