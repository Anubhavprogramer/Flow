//
//  PageScreenView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import SwiftUI

struct ScreenView: View{
    
    var screen: CanvasScreen
    
    
    var body: some View{
        Text("This is the Screen")
            .navigationTitle(screen.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}
