//
//  PinLocationsViewModel.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 12/5/21.
//

import Foundation
import SwiftUI
import MapKit

class PinLocationsViewModel: ObservableObject {
  
  @Published var annotationItems: [MyAnnotationItem]
  
  init() {
    
    //this should be in a services file probably
    //temporary storage for rn
    
    annotationItems =  [
        MyAnnotationItem(building: "Hardesty Hall", coordinate: CLLocationCoordinate2D(latitude: 36.1530000, longitude: -95.9444855)),
        MyAnnotationItem(building: "Keplinger Hall", coordinate: CLLocationCoordinate2D(latitude: 36.1538169, longitude: -95.9420573)),
    ]
    
  }

}
