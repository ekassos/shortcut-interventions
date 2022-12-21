//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Evangelos Kassos on 7/3/22.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    @StateObject var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView4()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
