//
//  SwipeActionsModifier.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI

// Like context menus, swipe actions are by their very nature hidden to the user by default, so it’s important not to hide important functionality in them. We’ll be using them both in this app, which should hopefully give you the chance to compare and contrast them directly!

struct SwipeActionsModifier: View {
    var body: some View {
        List {
            Text("Taylor Swift")
                .swipeActions { // by default, the edge is .trailing
                    Button(role: .destructive) {
                        print("Deleting...")
                    } label: {
                        // iOS enforce the '.fill' variant of the SF Symbols
                        Label("Delete", systemImage: "minus.circle")
                    }
                    // .tint won't work if the Button has already a role
                    Button {
                        print("Flagging...")
                    } label: {
                        // iOS enforce the '.fill' variant of the SF Symbols
                        Label("Flag", systemImage: "flag")
                    }
                    .tint(.blue)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    // by default, a full swipe is allowed and will perform the first action (here: print("Hi"))
                    Button {
                        print("Hi")
                    } label: {
                        Label("Pin", systemImage: "pin")
                    }
                    .tint(.orange)
                }
        }
    }
}

struct SwipeActionsModifier_Previews: PreviewProvider {
    static var previews: some View {
        SwipeActionsModifier()
    }
}
