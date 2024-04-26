//
//  dont_cutlossApp.swift
//  dont-cutloss
//
//  Created by user on 26/04/24.
//

import SwiftUI

@main
struct dont_cutlossApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
