//
//  MapViewModel.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/7/21.
//

import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(
        latitude: 36.1521,
        longitude: -95.9461)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01,
                                              longitudeDelta: 0.01)
}

final class MapViewModel: NSObject, ObservableObject,
    CLLocationManagerDelegate{
    
    @Published var region = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.defaultSpan)
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }
        else {
            print("Please turn on your location services for this map to work properly.")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return}
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("You location is restrcited for this application")
        case .denied:
            print("Location permissions denied. Please go into settings to change this.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
    
    
}
