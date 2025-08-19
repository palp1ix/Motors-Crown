import SwiftUI
import YandexMapsMobile

// NOTE: Ensure your Car model conforms to the Identifiable protocol.
// This is required for the .sheet(item:...) modifier to work correctly.
// Example:
/*
 struct Car: Identifiable {
     let id = UUID() // Or some unique identifier from your data source
     let title: String
     let price: Double
     let imageName: String
     // ... other properties
 }
 */

// MARK: - Main CarsMap View
struct CarsMap: View {
    
    // MARK: - State Properties
    
    /// The car currently selected on the map. When this property is not nil, the bottom sheet will be presented.
    @State private var selectedCarForBottomSheet: Car?
    
    /// The map point corresponding to the selected car. This can be used to move the map camera or for other interactions.
    @State private var selectedCarPoint: YMKPoint?

    // MARK: - Body
    
    var body: some View {
        ZStack {
            // The main map view. It updates the selectedCarForBottomSheet when a car is tapped.
            CarsMapView(
                selectedCar: $selectedCarForBottomSheet,
                selectedCarPoint: $selectedCarPoint
            )
            .edgesIgnoringSafeArea(.all)
        }
        // This is the modern, idiomatic SwiftUI way to present a sheet based on an optional state object.
        // The sheet is automatically presented when `selectedCarForBottomSheet` is non-nil.
        .sheet(item: $selectedCarForBottomSheet) { car in
            CarBottomSheetView(car: car)
                // Use presentation detents to make the sheet a true "bottom sheet" instead of a full-screen modal.
                // You can use .medium, .large, or specify a fixed height as shown below.
                .presentationDetents([.height(460)])
                // Shows a grabber handle at the top of the sheet, improving user experience.
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Bottom Sheet View
struct CarBottomSheetView: View {
    
    // MARK: - Properties
    
    /// The car data to display in the sheet.
    let car: Car
    
    /// The environment value that allows programmatically dismissing the view.
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        // The main container for the sheet content.
        VStack(alignment: .leading, spacing: 16) {
            
            // --- Car Image ---
            Image(car.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // --- Car Details ---
            VStack(alignment: .leading, spacing: 8) {
                Text(car.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryText)
                
                Text(String(format: "$%.2f", car.price))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.primaryAccent)
            }
            
            // --- Action Buttons ---
            HStack(spacing: 12) {
                Button(action: {
                    // Handle your contact logic here (e.g., make a call).
                    print("Contact button tapped for \(car.title)")
                    dismiss() // Dismiss the sheet after the action.
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Contact")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.icon)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.primaryAccent)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Button(action: {
                    // Handle your details navigation logic here.
                    print("Details button tapped for \(car.title)")
                    dismiss() // Dismiss the sheet after the action.
                }) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text("Details")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.primaryAccent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.primaryAccent.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}
