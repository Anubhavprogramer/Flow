//
//  HomeView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 25/07/26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showNewProjectSheet = false
    
    var body: some View {
        NavigationStack {
            VStack{
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(AppStrings.appName)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewProjectSheet = true
                    } label: {
                        Image(systemName: AppStrings.plusIcon)
                            .font(.title3.weight(.semibold))
                    }
                }
            }
            .sheet(isPresented: $showNewProjectSheet) {
                NewProjectView()
            }
        }
        
    }
    
}
