//
//  ShapeSettings.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 12/2/21.
//

import Foundation
import SwiftUI

class ShapeSettings: ObservableObject {
    @Published
    var showSettings = false
    
    static var Colors = [Color.red, Color.blue, Color.green, Color.purple, Color.orange]
    
    @Published
    var chosenColor = 0
    
    enum Shapes: String, CaseIterable {
        case Circle, Rectangle
    }
    
    @Published
    var chosenShape = Shapes.Circle
    
    @Published
    var scale = 0.5
    
    @Published
    var shapeCount = 5
    
    @Published
    var showShapes = true
    
}
