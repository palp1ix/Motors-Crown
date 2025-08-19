//
//  CarsMap.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/17/25.
//

import SwiftUI
import UIKit
import YandexMapsMobile

// A helper struct to combine a Car with its map coordinates.
struct CarPoint {
    let car: Car
    let point: YMKPoint
}

struct CarsMapView: UIViewRepresentable {
    
    // State to manage the currently selected car for showing bottom sheet.
    @Binding var selectedCar: Car?
    @Binding var selectedCarPoint: YMKPoint?
    
    // Mock data for cars on the map.
    private let carPoints = CarsMapView.generateCarPoints()

    func makeUIView(context: Context) -> YMKMapView {
        let mapView = YMKMapView()
        
        // Store the map view in coordinator for camera control
        context.coordinator.mapView = mapView
        
        // It's crucial to perform all UI-related work on the main thread.
        // This fixes the console warning and the initial lag.
        DispatchQueue.main.async {
            setupMapView(mapView, context: context)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: YMKMapView, context: Context) {
        // Center camera on selected car if needed
        if let selectedPoint = selectedCarPoint {
            centerCamera(on: selectedPoint, in: uiView)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func setupMapView(_ mapView: YMKMapView, context: Context) {
        // Move the map camera to Minsk.
        let map = mapView.mapWindow.map
        map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: 53.9, longitude: 27.56667), // Minsk center
                zoom: 10,
                azimuth: 0,
                tilt: 0
            )
        )
        
        // Add placemarks for each car.
        let mapObjects = map.mapObjects
        for carPoint in carPoints {
            let placemark = mapObjects.addPlacemark()
            placemark.geometry = carPoint.point
            
            // Set the car data to be retrieved on tap.
            placemark.userData = carPoint.car
            
            // Set a custom icon for the placemark.
            if let carIcon = UIImage(named: "car_pin") {
                placemark.setIconWith(carIcon)
            }
            
            // Add a tap listener to the placemark.
            placemark.addTapListener(with: context.coordinator)
        }
    }
    
    private func centerCamera(on point: YMKPoint, in mapView: YMKMapView) {
        let map = mapView.mapWindow.map
        map.move(
            with: YMKCameraPosition(
                target: point,
                zoom: 15, // Zoom closer when selecting a car
                azimuth: 0,
                tilt: 0
            ),
            animation: YMKAnimation(type: .smooth, duration: 1.0)
        )
    }

    // Coordinator to handle map events, like tapping on a placemark.
    class Coordinator: NSObject, YMKMapObjectTapListener {
        var parent: CarsMapView
        var mapView: YMKMapView?

        init(_ parent: CarsMapView) {
            self.parent = parent
        }

        // This method is called when a map object with a listener is tapped.
        func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
            // Try to cast the tapped object to a placemark and get the associated car data.
            if let placemark = mapObject as? YMKPlacemarkMapObject,
                let car = placemark.userData as? Car {
                
                // Update the parent's state to show the bottom sheet and center camera
                parent.selectedCar = car
                parent.selectedCarPoint = placemark.geometry
                
                return true // Event handled
            }
            return false // Event not handled
        }
    }
    
    // Generates a random list of car points within Minsk.
    static func generateCarPoints() -> [CarPoint] {
        var points: [CarPoint] = []
        let numberOfCars = Int.random(in: 10...50)
        
        // Minsk approximate bounding box
        let minLat = 53.83, maxLat = 53.7
        let minLon = 27.4, maxLon = 27.7
        // Just mock data for showing current flowl;
        let oneMockCar = MockCarService().fetchCars(filters: Filters()).first!
        
        for _ in 1...numberOfCars {
            let randomLat = Double.random(in: minLat...maxLat)
            let randomLon = Double.random(in: minLon...maxLon)
            
            let point = YMKPoint(latitude: randomLat, longitude: randomLon)
            
            points.append(CarPoint(car: oneMockCar, point: point))
        }
        return points
    }
}
