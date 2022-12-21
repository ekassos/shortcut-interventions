//
//  DataController.swift
//  CoreDataProject
//
//  Created by Evangelos Kassos on 7/3/22.
//

import CoreData

class DataController: ObservableObject {
    // prepare DataController for what data model we'll be working with
    let container = NSPersistentContainer(name: "CoreDataProject")

    // load stored data -- if anything goes wrong, we show an error message
    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }

        // This asks Core Data to merge duplicate objects based on their properties –
        // it tries to intelligently overwrite the version in its database using properties from the new version.
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    // create a single instance of DataController in CoreDataProjectApp.swift
}
