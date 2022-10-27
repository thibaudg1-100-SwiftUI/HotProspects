//
//  ImageInterpolation.swift
//  HotProspects
//
//  Created by RqwerKnot on 30/03/2022.
//

import SwiftUI

struct ImageInterpolation: View {
    var body: some View {
        // it’s taken from the Kenney Platform Art Deluxe bundle at https://kenney.nl/assets/platformer-art-deluxe and is available under the public domain.
        // Take a close look at the edges of the colors: they look jagged, but also blurry. The jagged part comes from the original image because it’s only 66x92 pixels in size, but the blurry part is where SwiftUI is trying to blend the pixels as they are stretched to make the stretching less obvious.
        
        // Often this blending works great, but it struggles here because the source picture is small (and therefore needs a lot of blending to be shown at the size we want), and also because the image has lots of solid colors so the blended pixels stand out quite obviously.
        
        // For situations just like this one, SwiftUI gives us the interpolation() modifier that lets us control how pixel blending is applied. There are multiple levels to this, but realistically we only care about one: .none. This turns off image interpolation entirely, so rather than blending pixels they just get scaled up with sharp edges.
        Image("example")
            .interpolation(.none) // if none is not set, SwiftUI will use a lot of blending
            .resizable()
            .scaledToFit()
            .frame(maxHeight: .infinity)
            .background(.black)
            .ignoresSafeArea()
    }
}

struct ImageInterpolation_Previews: PreviewProvider {
    static var previews: some View {
        ImageInterpolation()
    }
}
