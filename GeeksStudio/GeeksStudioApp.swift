//
//  GeeksStudioApp.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 30/8/24.
//

import SwiftUI

@main
struct GeeksStudioApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
