//
//  notepadApp.swift
//  notepad
//
//  Created by Hicret Ay on 15.10.2022.
//

import SwiftUI

@main
struct notepadApp: App {
    let persistentContainer = CoreDataManager.shared.persistentContainer

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
