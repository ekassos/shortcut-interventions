//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Evangelos Kassos on 7/3/22.
//

import SwiftUI
import CoreData

struct FilteredListOld: View {
    @FetchRequest var fetchRequest: FetchedResults<Singer>
    /// Because this view will be used inside ContentView, we don’t even need
    /// to inject a managed object context into the environment –
    /// it will inherit the context from ContentView.

    /// we’re not writing to the fetched results object inside our fetch request,
    /// but instead writing a wholly new fetch request.
    ///    `score` refers to the value inside the property wrapper.
    ///    `_score` refers to the property wrapper.
    ///    `$score` refers to the property wrapper's projected value; in the case of @State, that is a Binding.

    init(filter: String) {
        _fetchRequest = FetchRequest<Singer>(sortDescriptors: [],
                                             predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter))
    }

    var body: some View {
        List(fetchRequest, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
}

// Generic version
// Content: the parent View should give us Content of type View (what should be in the row)
struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>

    // I'll give you an element of type T, give me back some content
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest, id: \.self) { item in
            self.content(item)
        }
    }

    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T>(sortDescriptors: [],
                                        predicate: NSPredicate(format: "@K BEGINSWITH %@", filterKey, filterValue))
        self.content = content
    }
}

struct FilteredListChallenge<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>

    // I'll give you an element of type T, give me back some content
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest, id: \.self) { item in
            self.content(item)
        }
    }

    init(filterKey: String, predicateToUse: FilterMethod, descriptorsArray: [SortDescriptor<T>],
         filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T>(sortDescriptors: descriptorsArray,
                                        predicate: NSPredicate(format: "%K \(predicateToUse) %@",
                                                               filterKey, filterValue))
        self.content = content
    }

    enum FilterMethod: String {
        case beginsWith = "BEGINSWITH"
        case beginsWithCaseInsensitive = "BEGINSWITH[c]"
        case contains = "CONTAINS"
        case containsCaseInsensitive = "CONTAINS[c]"
        case endsWith = "ENDSWITH"
        case endsWithCaseInsensitive = "ENDSWITH[c]"
    }
}
