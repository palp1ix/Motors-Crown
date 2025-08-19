//
//  CarMapData.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/14/25.
//
import MapKit

struct CarMapData {
    let car: Car
    let coordinate: CLLocationCoordinate2D
    let city: String
    let additionalInfo: CarAdditionalInfo?
    
    init(car: Car, locationService: LocationService = .shared) {
        self.car = car
        self.coordinate = locationService.coordinateFor(car: car)
        self.city = locationService.cityFor(car: car)
        self.additionalInfo = locationService.additionalInfoFor(car: car)
    }
}

class LocationService {
    static let shared = LocationService()
    
    private let cityCoordinates: [String: CLLocationCoordinate2D] = [
        "Москва": CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
        "СПб": CLLocationCoordinate2D(latitude: 59.9311, longitude: 30.3609),
        "Казань": CLLocationCoordinate2D(latitude: 55.8304, longitude: 49.0661),
        "Екатеринбург": CLLocationCoordinate2D(latitude: 56.8431, longitude: 60.6454),
        "Новосибирск": CLLocationCoordinate2D(latitude: 55.0084, longitude: 82.9357)
    ]
    
    func coordinateFor(car: Car) -> CLLocationCoordinate2D {
        let city = cityFor(car: car)
        let baseCoordinate = cityCoordinates[city] ?? cityCoordinates["Москва"]!
        
        // Add random
        let hash = abs(car.id.hashValue)
        let latOffset = Double(hash % 100) / 10000.0 - 0.005 // +- 5 deegres
        let lonOffset = Double((hash / 100) % 100) / 10000.0 - 0.005
        
        return CLLocationCoordinate2D(
            latitude: baseCoordinate.latitude + latOffset,
            longitude: baseCoordinate.longitude + lonOffset
        )
    }
    
    func cityFor(car: Car) -> String {
        let cities = Array(cityCoordinates.keys)
        let hash = abs(car.title.hashValue)
        return cities[hash % cities.count]
    }
}
