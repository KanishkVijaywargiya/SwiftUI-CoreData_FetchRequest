//
//  CoreDataBootcamp_FetchRequestApp.swift
//  CoreDataBootcamp_FetchRequest
//
//  Created by KANISHK VIJAYWARGIYA on 02/03/22.
//

import SwiftUI

@main
struct CoreDataBootcamp_FetchRequestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
