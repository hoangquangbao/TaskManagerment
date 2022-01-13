//
//  TaskManagermentApp.swift
//  TaskManagerment
//
//  Created by Quang Bao on 13/01/2022.
//

import SwiftUI

@main
struct TaskManagermentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
