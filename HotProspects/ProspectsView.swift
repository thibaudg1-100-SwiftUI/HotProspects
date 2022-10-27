//
//  ProspectsView.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI
import CodeScanner
import UserNotifications

enum FilterType: CaseIterable {
    case none, contacted, uncontacted
}

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    // When you use @EnvironmentObject you are explicitly telling SwiftUI that your object will exist in the environment by the time the view is created. If it isn’t present, your app will crash immediately – be careful, and treat it like an implicitly unwrapped optional.
    
    // List and ForEach can use not only stored properties but also computed properties as a source:
    // This computed property is not a @State or a @Published, but since it is in the body var of this View, it will get reasserted if the body var is reinvoked, and the body will get reinvoked if a @State, @StateObject, @ObservedObject or @EnvironmentObject changes...
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    // Manage the sorting choice: either custom Comparable implementation from Prospect class or most recently added item in the array first:
    var sortedProspects: [Prospect] {
        sortAZ ?
        filteredProspects.sorted()
        :
        filteredProspects.reversed()
    }
    
    @State private var sortAZ = false
    @State private var showSortingDialog = false
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    @State private var isShowingScanner = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        
                        if filter == .none {
                            Spacer()
                        
                            Image(systemName: prospect.isContacted ? "checkmark.circle" : "questionmark.diamond")
                                .frame(width: 20, height: 20, alignment: .center)
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                                Button {
                                    /*
                                     While the text for that is OK and the context menu displays correctly, the action doesn’t do anything. Well, that’s not strictly true: it does toggle the Boolean, but it doesn’t actually update the UI.

                                     This problem occurs because the people array in Prospects is marked with @Published, which means if we add or remove items from that array a change notification will be sent out. However, if we quietly change an item inside the array then SwiftUI won’t detect that change, and no views will be refreshed.
                                     
                                     This is a side effect of choosing a class for Prospect objects
                                     */
                                    //prospect.isContacted.toggle()
                                    
                                    prospects.toggle(prospect) // that will work properly
                                } label: {
                                    Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                                }
                                .tint(.blue)
                            } else {
                                Button {
                                    //prospect.isContacted.toggle() // not working: see above
                                    prospects.toggle(prospect)
                                } label: {
                                    Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                                }
                                .tint(.green)
                                
                                Button {
                                    addNotification(for: prospect)
                                } label: {
                                    Label("Remind Me", systemImage: "bell")
                                }
                                .tint(.orange)
                            }
                }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSortingDialog = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down.square")
                    }
                }                
            }
            .sheet(isPresented: $isShowingScanner) {
                // don't forget to add an entry in info.plist for Camera Privacy
                CodeScannerView(codeTypes: [.qr], simulatedData: "Madonna\npaul@hackingwithswift.com", completion: handleScan)
            }
            .confirmationDialog("Choose a sort order", isPresented: $showSortingDialog, titleVisibility: .visible) {
                Button("Most recently added first") { sortAZ = false }
                Button("Alphabetical order") { sortAZ = true }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
       isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]

            prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        // That puts all the code to create a notification for the current prospect into a closure called 'addRequest':
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            // For testing purposes, I recommend you comment out that trigger code and replace it with the following, which shows the alert five seconds from now:
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                    addRequest()
                } else {
                    center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            addRequest()
                        } else {
                            print("D'oh")
                        }
                    }
                }
        }

        // more code to come
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(FilterType.allCases, id: \.self) { fType in
            ProspectsView(filter: fType)
        }
        .environmentObject(Prospects())
    }
}
