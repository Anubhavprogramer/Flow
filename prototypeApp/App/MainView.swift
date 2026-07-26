//
//  Main.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 24/07/26.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var appState: AppStats
    
    
    var body: some View {
        NavigationStack(path: $appState.path) {
            Group{
                if !appState.hasSeenIntro {
                    IntroView()
                } else {
                    HomeView()
                }
            }
        }
        .dismissKeyboardOnTap()
    }
}
