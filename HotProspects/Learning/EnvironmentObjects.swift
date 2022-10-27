//
//  EnvironmentObjects.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI

@MainActor class User: ObservableObject {
    @Published var name = "Taylor Swift"
}

// That @EnvironmentObject property wrapper will automatically look for a User instance in the environment, and place whatever it finds into the user property. If it can’t find a User in the environment your code will just crash, so please be careful.
struct EditView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        TextField("Name", text: $user.name)
    }
}

struct DisplayView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        Text(user.name)
    }
}

struct EnvironmentObjects: View {
    // Given that we are explicitly sharing our User instance with other views, I would personally be inclined to remove the private access control because it’s not accurate.
    @StateObject var user = User()
    
    var body: some View {
        VStack {
            EditView().environmentObject(user)
            DisplayView().environmentObject(user)
        }
        
        // alternatively:
//        VStack {
//            EditView()
//            DisplayView()
//        }
//        .environmentObject(user)
    }
}

// Now, you might wonder how SwiftUI makes the connection between .environmentObject(user) and @EnvironmentObject var user: User – how does it know to place that object into the correct property?

// Well, you’ve seen how dictionaries let us use one type for the key and another for the value. The environment effectively lets us use data types themselves for the key, and instances of the type as the value. This is a bit mind bending at first, but imagine it like this: the keys are things like Int, String, and Bool, with the values being things like 5, “Hello”, and true, which means we can say “give me the Int” and we’d get back 5.

struct EnvironmentObjects_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentObjects()
    }
}
