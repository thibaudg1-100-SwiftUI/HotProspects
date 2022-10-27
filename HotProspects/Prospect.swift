//
//  Prospect.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import Foundation

/*
 Yes, that’s a class rather than a struct. This is intentional, because it allows us to modify instances of the class directly and have it be updated in all other views at the same time. Remember, SwiftUI takes care of propagating that change to our views automatically, so there’s no risk of views getting stale.
 */
class Prospect: Identifiable, Codable, Comparable, Equatable {
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.name < rhs.name
    }
    
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    // There’s a specific access control option called fileprivate, which means “this property can only be used by code inside the current file.” Of course, we still want to read that property, and so we can deploy another useful Swift feature: fileprivate(set), which means “this property can be read from anywhere, but only written from the current file” – the exact combination we need to make sure the Boolean is safe to use.
    
    // This will force anyone to use the Prospects method 'toggle' to write a new Boolean value to 'isContacted', and ensure that the publisher will emit a change signal to the UI
    
    // It's the reason we put the Prospect and Prospects classes in the same file!
}

@MainActor class Prospects: ObservableObject {
    // Even better, we can use access control to stop external writes to the people array, meaning that our views must use the add() method to add prospects. This is done by changing the definition of the people property to 'private(set)':
    @Published private(set) var people: [Prospect]
    
    // We’ve had to hard-code the key name “SavedData” in two places, which again might cause problems in the future if the name changes or needs to be used in more places. To fix the first problem we should create a property on Prospects to contain our save key, so we use that property rather than a string for UserDefaults.
    let saveKey = "SavedData"
    
    init() {
        // try to load data from UserDefaults:
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        
        // default to empty array if we cannot retrieve any saved data:
        people = []
    }
    
    // To fix this, we need to tell SwiftUI by hand that something important has changed. So, rather than flipping a Boolean in ProspectsView, we are instead going to call a method on the Prospects class to flip that same Boolean while also sending a change notification out.
    func toggle(_ prospect: Prospect) {
        // Important: You should call objectWillChange.send() before changing your property, to ensure SwiftUI gets its animations correct.
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    // As for the problem of calling save(), this is actually a deeper problem: when we write code like prospects.people.append(person) we’re breaking a software engineering principle known as encapsulation. This is the idea that we should limit how much external objects can read and write values inside a class or a struct, and instead provide methods for reading (getters) and writing (setters) that data.
    // since only code inside our Prospects class can change the people array, only code inside this same class should be able to use the save() method, and this is done by adding 'private':
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    // In practical terms, this means rather than writing prospects.people.append(person) we’d instead create an add() method on the Prospects class, so we could write code like this: prospects.add(person). The result would be the same – our code adds a person to the people array – but now the implementation is hidden away. This means that we could switch the array out to something else and ProspectsView wouldn’t break, but it also means we can add extra functionality to the add() method.
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
}
