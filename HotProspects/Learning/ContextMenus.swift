//
//  ContextMenus.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI

/*
 I have a few tips for you when working with context menus, to help ensure you give your users the best experience:

     If you’re going to use them, use them in lots of places – it can be frustrating to press and hold on something only to find nothing happens.
     Keep your list of options as short as you can – aim for three or less.
     Don’t repeat options the user can already see elsewhere in your UI.

 Remember, context menus are by their nature hidden, so please think twice before hiding important actions in a context menu.
 */

struct ContextMenus: View {
    @State private var backgroundColor = Color.red
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
                .background(backgroundColor)
            
            Text("Change Color")
                .padding()
                .contextMenu {
                    Button(role: .destructive) {
                        backgroundColor = .red
                    } label: {
                        Label("Red", systemImage: "checkmark.circle.fill")
                    }
                    
                    // Now, there is a catch here: to keep user interfaces looking somewhat uniform across apps, iOS renders each image as a solid color where the opacity is preserved. This makes many pictures useless: if you had three photos of three different dogs, all three would be rendered as a plain black square because all the color got removed.
                    
                    // Instead, you should aim for line art icons such as Apple’s SF Symbols, like this:
                    Button {
                        backgroundColor = .green
                    } label: {
                        Label("Green", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        //When you run that you’ll see the foregroundColor() modifier is ignored – iOS really does want our menus to look uniform, so trying to color them randomly just won’t work.
                    }
                    
                    Button("Blue") {
                        backgroundColor = .blue
                    }
                }
        }
    }
}

struct ContextMenus_Previews: PreviewProvider {
    static var previews: some View {
        ContextMenus()
    }
}
