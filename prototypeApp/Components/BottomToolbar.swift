//
//  BottomToolbar.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//

import SwiftUI

struct BottomToolbar: View {
    var body: some View {
        HStack(spacing: AppSpacing.xl) {
            Image(systemName: AppStrings.pencil)
                .resizable()
                .frame(width: 30, height: 30)
            
            Image(systemName: AppStrings.square)
                .resizable()
                .frame(width: 30, height: 30)
            
            Image(systemName: AppStrings.circle)
                .resizable()
                .frame(width: 30, height: 30)
            
            Image(systemName: AppStrings.textFormat)
                .resizable()
                .frame(width: 30, height: 30)
            
            Image(systemName: AppStrings.photo)
                .resizable()
                .frame(width: 30, height: 30)
        }
        .font(.title2)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(.bottom)
    }
    
}
