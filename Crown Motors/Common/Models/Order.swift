//
//  Order.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/13/25.
//
import SwiftUI

struct Order: Equatable, Identifiable, Hashable, Storable {
    var id: UUID
    var car: Car
    var vinNumber: String
    var color: Color
    var colorName: String
    var engineVolume: Float
    var currentStatus: OrderStatus
    var currentPosition: String
    var contactNumber: String
}

enum OrderStatus: String {
    case inDelivery = "In Delivery"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    case preparing = "Preparing"
}


