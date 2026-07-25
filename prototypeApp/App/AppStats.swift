//
//  AppStats.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import Combine
import SwiftUI

@MainActor
class AppStats: ObservableObject {
    
    @Published var path = NavigationPath()
    
    @AppStorage(UserDefaultsKeys.hasSeenIntro)
    var hasSeenIntro: Bool = false
    
    
}
