//
//  IntroView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import SwiftUI

struct IntroView: View {
    
    @EnvironmentObject private var appState: AppStats
    var body: some View {
        VStack {
            
            
            Spacer()
            
            Text("Welcoome to the Flow")
                
            
            Spacer()
            
            Button{
                appState.hasSeenIntro = true
            } label: {
                VStack{
                    Text("Continue")
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.black)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: AppCorners.xxxl))
                
            }
            .padding(.horizontal)
        }
    }
}
