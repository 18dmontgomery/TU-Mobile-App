//
//  MyAnnotationItem.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 12/5/21.
//

import Foundation
import SwiftUI
import MapKit

struct MyAnnotationItem: Identifiable {
    var building: String
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}
