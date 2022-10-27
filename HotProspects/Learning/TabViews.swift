//
//  TabViews.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI

struct TabViews: View {
    
    @State private var selectedTab = TabViews.tabOne
    
    // better create simple static let to avoid typing String later, avoid typos and all, and allows for autocompletion:
    static let tabOne = "TabOne"
    static let tabTwo = "TabTwo"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Text("Tab 1")
            // switch tabs programmaticaly, for example with a tap gesture here:
                .onTapGesture {
                    selectedTab = TabViews.tabTwo // let's go to tag: TabTwo
                }
                .tabItem {
                    // Only use Text or/and Image for tabItem content:
                    Label("One", systemImage: "star") // Label seems to fit the constraint above
                }
                .tag(TabViews.tabOne) // don't forget to add a tag on every tabItem, otherwise the programmatic tab switching won't work properly
            
            Text("Tab 2")
                .tabItem {
                    Image(systemName: "circle")
                    Text("Two")
                }
                .tag(TabViews.tabTwo)
                .badge(3)
        }
    }
}

struct TabViews_Previews: PreviewProvider {
    static var previews: some View {
        TabViews()
    }
}
