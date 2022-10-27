//
//  MeView.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI
import CoreImage.CIFilterBuiltins // required for QRCode filter from Core Image

struct MeView: View {
    
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    // property that will store the code we generate:
    @State private var qrCode = UIImage()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                
                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                
                // In terms of the string to pass in to generateQRCode(from:), we’ll be using the name and email address entered by the user, separated by a line break. This is a nice and simple format, and it’s easy to reverse when it comes to scanning these codes later on.
                Image(uiImage: qrCode)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        Button {
                            
                            //let image = generateQRCode(from: "\(name)\n\(emailAddress)")
                            // We could save a little work by caching the generated QR code, however a more important side effect of that is that we wouldn’t have to pass in the name and email address each time – duplicating that data means if we change one copy in the future we need to change the other too, and is prone to typos.
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
            }
            .navigationTitle("Your code")
            // The smart thing to do here is tell our image to render directly from the cached qrImage property, then call generateQRCode() when the view appears and whenever either name or email address changes.
            .onAppear(perform: updateCode)
            .onChange(of: name) { _ in
                updateCode()
            }
            .onChange(of: emailAddress) { _ in
                updateCode()
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        // the input for the filter is Data, so we need to convert that:
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg) // original code
                
                // Do not use the following code, it will enter an infinite loop when SwiftUI is reinvoking the body of View because changing a @State var during a view update will force SwiftUI to reinvoke the body var, and on and on again...
                // "Modifying state during view update, this will cause undefined behavior"
                //qrCode = UIImage(cgImage: cgimg)
                //return qrCode
                
                // https://www.hackingwithswift.com/books/ios-swiftui/adding-a-context-menu-to-an-image
            }
        }
        
        // If conversion fails for any reason we’ll send back the “xmark.circle” image from SF Symbols. If that can’t be read – which is theoretically possible because SF Symbols is stringly typed – then we’ll send back an empty UIImage.
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
