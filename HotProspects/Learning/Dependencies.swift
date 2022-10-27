//
//  Dependencies.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI

// Xcode comes with a dependency manager built in, called Swift Package Manager (SPM). You can tell Xcode the URL of some code that’s stored online, and it will download it for you. You can even tell it what version to download, which means if the remote code changes sometime in the future you can be sure it won’t break your existing code.

import SamplePackage

struct Dependencies: View {
    // typical lottery numbers:
    let possibleNumbers = 1...60 // or: Array(1...60) which is not exactly the same thing but produces the results we expect
    
    var results: String {
        // typical bet of 7 numbers:
        let selected = possibleNumbers.random(7).sorted()
        
        // This only takes one line of code in Swift, because sequences have a map() method that lets us convert an array of one type into an array of another type by applying a function to each element.
        let strings = selected.map(String.init)
        
        return strings.joined(separator: ", ")
    }
    
    var body: some View {
            Text(results)
        }
}

struct Dependencies_Previews: PreviewProvider {
    static var previews: some View {
        Dependencies()
    }
}

/*
 Anyway, the first step is to add the package to our project: go to the File menu and choose Add Packages. For the URL enter https://github.com/twostraws/SamplePackage, which is where the code for my example package is stored. Xcode will fetch the package, read its configuration, and show you options asking which version you want to use. The default will be “Version – Up to Next Major”, which is the most common one to use and means if the author of the package updates it in the future then as long as they don’t introduce breaking changes Xcode will update the package to use the new versions.

 The reason this is possible is because most developers have agreed a system of semantic versioning (SemVer) for their code. If you look at a version like 1.5.3, then the 1 is considered the major number, the 5 is considered the minor number, and the 3 is considered the patch number. If developers follow SemVer correctly, then they should:

     Change the patch number when fixing a bug as long as it doesn’t break any APIs or add features.
     Change the minor number when they added features that don’t break any APIs.
     Change the major number when they do break APIs.

 This is why “Up to Next Major” works so well, because it should mean you get new bug fixes and features over time, but won’t accidentally switch to a version that breaks your code.
 */
