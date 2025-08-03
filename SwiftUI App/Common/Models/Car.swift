//
//  Car.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//
import Foundation

struct Car: Identifiable, Hashable, Storable {
    var id: UUID
    var imageName: String
    var title: String
    var price: Double
}
