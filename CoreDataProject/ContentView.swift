//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Evangelos Kassos on 7/3/22.
//

import SwiftUI
import CoreData

// Core Data conforms to Hashable by default
/// Although calculating the same hash for an object twice in a row should return the same value,
/// calculating it between two runs of your app – i.e., calculating the hash, quitting the app, relaunching,
/// then calculating the hash again – can return different values.

struct Student: Hashable {
    let name: String
}

struct ContentView: View {
    let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]

    var body: some View {
        List(students, id: \.self) { student in
            Text(student.name)
        }
    }
}

struct ContentView2: View {
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>

    var body: some View {
        VStack {
            List(wizards, id: \.self) { wizard in
                Text(wizard.name ?? "Unknown")
            }

            Button("Add") {
                let wizard = Wizard(context: moc)
                wizard.name = "Harry Potter"
            }

            Button("Save") {
                if moc.hasChanges {
                    do {
                        try moc.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct ContentView3: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate:
                    NSPredicate(format: "universe == 'Star Wars'")) var ships: FetchedResults<Ship>

    /// Other NSPredicate options:
    ///  (same as above code)
    ///     `NSPredicate(format: "universe == %@", "Star Wars"))`
    ///  (filter objects, return Defiant, Enterprise, and Executor, before F)
    ///     `NSPredicate(format: "name < %@", "F"))`
    ///  (check whether the universe is one of three options from an array)
    ///     `NSPredicate(format: "universe IN %@", ["Aliens", "Firefly", "Star Trek"])`
    ///  (return all ships that start with a capital E)
    ///     `NSPredicate(format: "name BEGINSWITH %@", "E"))`
    ///  (if you want to ignore case)
    ///     `NSPredicate(format: "name BEGINSWITH[c] %@", "e"))`
    /// `CONTAINS[c]` works similarly, except rather than starting
    /// with your substring it can be anywhere inside the attribute.
    ///  (finds all ships that don’t start with an E)
    ///     `NSPredicate(format: "NOT name BEGINSWITH[c] %@", "e"))`
    ///  If you need more complicated predicates, join them using `AND` to build up as much precision as you need,
    ///  or add an import for Core Data and take a look at `NSCompoundPredicate` –
    ///  it lets you build one predicate out of several smaller ones.

    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }

            Button("Add Examples") {
                let ship1 = Ship(context: moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"

                let ship2 = Ship(context: moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"

                let ship3 = Ship(context: moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"

                let ship4 = Ship(context: moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"

                try? moc.save()
            }
        }
    }
}

struct ContentView4: View {
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "A"

    var body: some View {
        VStack {
///           Important detail: (singer: Singer) specifies type of element, needed forn Swift
//            FilteredList(filterKey: "lastName", filterValue: lastNameFilter) { (singer: Singer) in
//                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
//            }

            FilteredListChallenge(filterKey: "lastName", predicateToUse: .beginsWith,
                                  descriptorsArray: [], filterValue: lastNameFilter) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }

            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"

                let edSheeran = Singer(context: moc)
                edSheeran.firstName = "Ed"
                edSheeran.lastName = "Sheeran"

                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"

                try? moc.save()
            }

            Button("Show A") {
                lastNameFilter = "A"
            }

            Button("Show S") {
                lastNameFilter = "S"
            }
        }
    }
}

struct ContentView5: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>

    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(country.wrappedFullName) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }

            Button("Add") {
                let candy1 = Candy(context: moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"

                let candy2 = Candy(context: moc)
                candy2.name = "KitKat"
                candy2.origin = Country(context: moc)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"

                let candy3 = Candy(context: moc)
                candy3.name = "Twix"
                candy3.origin = Country(context: moc)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"

                let candy4 = Candy(context: moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"

                try? moc.save()
            }
        }
    }
}

/// As very rough guidance, you should:
/// 1. Aim to use ternary conditional operators rather than use if conditions.
/// 2. Prefer to break large views up into smaller views rather than add complex logic in your view hierarchy.
/// 3. Use Group to avoid the 10-view limit, or to add modifier such as navigationTitle() where
///     it would otherwise not be possible.
/// 4. Use an explicit @ViewBuilder only for simple properties, but be wary of using it to mask complex logic
///     when really a new view might make more sense.
/// 5. Fall back on AnyView if none of the other options would work.

extension View {
    func erasedToAnyView() -> AnyView {
        AnyView(self)
    }
}

struct ContentView13: View {
    var body: some View {
        Text("Hello World")
            .font(.title)
            .erasedToAnyView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView4()
    }
}
