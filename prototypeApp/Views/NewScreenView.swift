//
//  NewScreenView.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import SwiftUI
import SwiftData

struct NewScreenView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel = NewScreenViewModel()
    
    let project: Project
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: AppSpacing.s){
                Form{
                    Section("Screen Name"){
                        TextField("Screen Name", text: $viewModel.ScreenName)
                    }
                }
            }
            .navigationTitle("Add New Screen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        viewModel.createNewScreen(in: project, context: context)
                        dismiss()
                    } label: {
                        Image(systemName: AppStrings.doneButton)
                    }
                }
                ToolbarItem(placement: .topBarLeading){
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: AppStrings.backButton)
                    }
                }
            }
        }
    }
}
