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
        ZStack {
            // Crisp Pure White Background
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // 1. Floating Hero Mockup Card (Black & Shades of Black)
                ZStack {
                    // Back card shadow layer
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color(white: 0.2))
                        .frame(width: 260, height: 170)
                        .rotationEffect(.degrees(-6))
                        .offset(y: 10)
                    
                    // Front jet black card layer
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Circle()
                                .fill(Color(white: 0.3))
                                .frame(width: 8, height: 8)
                            Circle()
                                .fill(Color(white: 0.5))
                                .frame(width: 8, height: 8)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                            Spacer()
                            Text("FIGMA CANVAS")
                                .font(.caption2.weight(.heavy))
                                .foregroundStyle(Color(white: 0.7))
                        }
                        
                        HStack(spacing: 10) {
                            Text("Login Wireframe")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "link.circle.fill")
                                .foregroundStyle(.white)
                        }
                        
                        HStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: "hand.tap.fill")
                                Text("Button")
                            }
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.white)
                            .clipShape(Capsule())
                            
                            HStack(spacing: 4) {
                                Image(systemName: "textformat")
                                Text("Input")
                            }
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(white: 0.25))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(20)
                    .frame(width: 270, height: 160)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                }
                .padding(.bottom, 20)
                
                // 2. Black & White Brand Header
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.black)
                        Text("FLOW WIREFRAME STUDIO")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Color(white: 0.3))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(white: 0.94))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.black.opacity(0.12), lineWidth: 1))
                    
                    Text("Sketch Wireframes.\nPrototype Flows.")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                }
                .padding(.horizontal, 24)
                
                // 3. Black Feature Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        featureChip(icon: "pencil.tip.crop.line", text: "Pencil Sketches")
                        featureChip(icon: "square.grid.2x2.fill", text: "Figma UI Elements")
                        featureChip(icon: "link", text: "Interactive Screen Links")
                        featureChip(icon: "iphone", text: "iPhone Prototype")
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // 4. Jet Black CTA Button
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        appState.hasSeenIntro = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Get Started with Flow")
                            .font(.subheadline.weight(.bold))
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title3)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
    }
    
    @ViewBuilder
    private func featureChip(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(.white)
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(white: 0.12))
        .clipShape(Capsule())
    }
}
