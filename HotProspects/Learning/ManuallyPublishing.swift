//
//  ManuallyPublishing.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI

@MainActor class DelayedUpdater: ObservableObject {
    // Every class that conforms to ObservableObject automatically gains a property called objectWillChange. This is a publisher, which means it does the same job as the @Published property wrapper: it notifies any views that are observing that object that something important has changed. As its name implies, this publisher should be triggered immediately before we make our change, which allows SwiftUI to examine the state of our UI and prepare for animation changes.
    
    // Automatic synthesis of objectWillChange, using the built-in @Published property wrapper:
    //@Published var value = 0
    
    // Manual use of Publisher:
    var value = 0 {
        // Now you’ll get the old behavior back again – the UI will count to 10 as before. Except this time we have the opportunity to add extra functionality inside that willSet observer. Perhaps you want to log something, perhaps you want to call another method, or perhaps you want to clamp the integer inside value so it never goes outside of a range – it’s all under our control now.
        willSet {
            // here goes any custom code before sending the change notification...
            objectWillChange.send()
            // here goes any custom code after sending the change notification...
        }
    }

    init() {
        for i in 1...10 {
            // We’re going to use a method called DispatchQueue.main.asyncAfter(), which lets us run an attached closure after a delay of our choosing, which means we can say “do this work after 1 second” rather than “do this work now.”
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ManuallyPublishing: View {
    
    @StateObject var updater = DelayedUpdater()

        var body: some View {
            Text("Value is: \(updater.value)")
        }
}

struct ManuallyPublishing_Previews: PreviewProvider {
    static var previews: some View {
        ManuallyPublishing()
    }
}
