//
//  SwiftResult.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI

struct SwiftResult: View {
    
    @State private var output = ""
    
    var body: some View {
        Text(output)
            .task {
                // basic way of fetching data:
                //await basicFetchReadings()
                
                // Using Task and Result:
                await evolvedFetchReadings()
            }
    }
    
    func basicFetchReadings() async {
        do {
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            output = "Found \(readings.count) readings"
        } catch {
            print("Download error")
        }
        
        // That code works just fine, but it doesn’t give us a lot of flexibility – what if we want to stash the work away somewhere and do something else while it’s running? What if we want to read its result at some point in the future, perhaps handling any errors somewhere else entirely? Or what if just want to cancel the work because it’s no longer needed?
    }
    
    // Well, we can get all that by using Result, and it’s actually available through an API you’ve met previously: Task. We could rewrite the above code to this:
    func evolvedFetchReadings() async {
        let fetchTask = Task { () -> String in
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found \(readings.count) readings"
        }
        
        // We’ve used Task before to launch pieces of work, but here we’ve given the Task object the name of fetchTask – that’s what gives us the extra flexibility to pass it around, or cancel it if needed. And notice how our Task closure returns a value now? That value gets stored in our Task instance so that we can read it in the future when we’re ready.
        
        //fetchTask.cancel()
        
        
        // More importantly, that Task might have thrown an error if the network fetch failed, or if the data decoding failed, and that’s where Result comes in: the result of our task might be a string saying “Found 10000 readings”, but it might also contain an error. The only way to find out is to look inside – it’s very similar to optionals.
        
        let result = await fetchTask.result
        // type of result, you’ll see it’s a Result<String, Error>
        
        do {
            output = try result.get()
        } catch {
            output = "Error: \(error.localizedDescription)"
        }
        
        // Alternatively, you can switch on the Result
        switch result {
            case .success(let str):
                output = str
            case .failure(let error):
                output = "Error: \(error.localizedDescription)"
        }
    }
}

struct SwiftResult_Previews: PreviewProvider {
    static var previews: some View {
        SwiftResult()
    }
}
