//
//  CanvasViewModel.swift
//  prototypeApp
//
//  Created by Anubhav Dubey on 26/07/26.
//
import Combine
import PencilKit

@MainActor
final class CanvasViewModel: ObservableObject {
    @Published var drawing = PKDrawing()
}
