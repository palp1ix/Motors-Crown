//
//  CarServiceTests.swift
//  SwiftUI App Tests
//
//  Created by Test Generator
//

import XCTest
@testable import SwiftUI_App

final class CarServiceTests: XCTestCase {
    
    var mockCarService: MockCarService!
    
    override func setUp() {
        super.setUp()
        mockCarService = MockCarService()
    }
    
    override func tearDown() {
        mockCarService = nil
        super.tearDown()
    }
    
    // MARK: - Happy Path Tests
    
    func testFetchCars_WithEmptyPromptAndDefaultPriceRange_ReturnsAllCars() {
        // Given
        let filters = Filters(promptText: "", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 6, "Should return all 6 cars when no filters applied")
        XCTAssertTrue(result.contains { $0.title.contains("Mercedes-Benz") })
        XCTAssertTrue(result.contains { $0.title.contains("BMW M5") })
        XCTAssertTrue(result.contains { $0.title.contains("Audi RS7") })
        XCTAssertTrue(result.contains { $0.title.contains("Porsche Panamera") })
        XCTAssertTrue(result.contains { $0.title.contains("Tesla Model S") })
        XCTAssertTrue(result.contains { $0.title.contains("Lexus LC") })
    }
    
    func testFetchCars_WithValidPromptText_ReturnsMatchingCars() {
        // Given
        let filters = Filters(promptText: "BMW", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return only BMW car")
        XCTAssertEqual(result.first?.title, "BMW M5 Competition 2022")
        XCTAssertEqual(result.first?.price, 63450)
    }
    
    func testFetchCars_WithCaseInsensitivePrompt_ReturnsMatchingCars() {
        // Given
        let filters = Filters(promptText: "mercedes", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return Mercedes car with case-insensitive search")
        XCTAssertEqual(result.first?.title, "Mercedes-Benz 2021 Grand Coupe")
    }
    
    func testFetchCars_WithUppercasePrompt_ReturnsMatchingCars() {
        // Given
        let filters = Filters(promptText: "TESLA", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return Tesla car with uppercase search")
        XCTAssertEqual(result.first?.title, "Tesla Model S Plaid 2023")
    }
    
    func testFetchCars_WithPriceRangeFiltering_ReturnsCorrectCars() {
        // Given - Filter for cars between $60,000 and $80,000
        let filters = Filters(promptText: "", minPrice: 60000, maxPrice: 80000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 2, "Should return BMW and Audi cars in price range")
        let prices = result.map { $0.price }
        XCTAssertTrue(prices.contains(63450), "Should contain BMW price")
        XCTAssertTrue(prices.contains(71320), "Should contain Audi price")
    }
    
    func testFetchCars_WithCombinedFilters_ReturnsCorrectCars() {
        // Given - Search for "2022" models under $70,000
        let filters = Filters(promptText: "2022", minPrice: 0, maxPrice: 70000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return only BMW M5 2022")
        XCTAssertEqual(result.first?.title, "BMW M5 Competition 2022")
    }
    
    // MARK: - Edge Cases
    
    func testFetchCars_WithEmptyPromptAndNarrowPriceRange_ReturnsFilteredCars() {
        // Given - Very narrow price range
        let filters = Filters(promptText: "", minPrice: 54000, maxPrice: 55000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return only Mercedes in narrow price range")
        XCTAssertEqual(result.first?.title, "Mercedes-Benz 2021 Grand Coupe")
    }
    
    func testFetchCars_WithPromptNotFound_ReturnsEmptyArray() {
        // Given
        let filters = Filters(promptText: "Ferrari", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array for non-existent car brand")
    }
    
    func testFetchCars_WithMaxPriceLowerThanAllCars_ReturnsEmptyArray() {
        // Given
        let filters = Filters(promptText: "", minPrice: 0, maxPrice: 10000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array when max price too low")
    }
    
    func testFetchCars_WithMinPriceHigherThanAllCars_ReturnsEmptyArray() {
        // Given
        let filters = Filters(promptText: "", minPrice: 150000, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array when min price too high")
    }
    
    func testFetchCars_WithMinPriceEqualToMaxPrice_ReturnsEmptyArray() {
        // Given
        let filters = Filters(promptText: "", minPrice: 60000, maxPrice: 60000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array when min equals max price")
    }
    
    func testFetchCars_WithWhitespaceOnlyPrompt_TreatsAsEmptyPrompt() {
        // Given
        let filters = Filters(promptText: "   ", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        // Note: This tests current behavior - whitespace is not treated as empty
        XCTAssertTrue(result.isEmpty, "Should return empty array for whitespace-only prompt")
    }
    
    func testFetchCars_WithPartialModelMatch_ReturnsMatchingCars() {
        // Given
        let filters = Filters(promptText: "Coupe", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 2, "Should return Mercedes and Lexus coupes")
        let titles = result.map { $0.title }
        XCTAssertTrue(titles.contains("Mercedes-Benz 2021 Grand Coupe"))
        XCTAssertTrue(titles.contains("Lexus LC 500h Coupe 2022"))
    }
    
    func testFetchCars_WithPartialYearMatch_ReturnsMatchingCars() {
        // Given
        let filters = Filters(promptText: "202", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 6, "Should return all cars as they all contain '202' in year")
    }
    
    // MARK: - Boundary Value Tests
    
    func testFetchCars_WithExactMinPrice_ExcludesCarAtMinPrice() {
        // Given - Set min price to exact BMW price
        let filters = Filters(promptText: "", minPrice: 63450, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertFalse(result.contains { $0.price == 63450 }, "Should exclude car at exact min price")
        XCTAssertEqual(result.count, 3, "Should return Audi, Porsche, and Tesla (above min price)")
    }
    
    func testFetchCars_WithExactMaxPrice_IncludesCarBelowMaxPrice() {
        // Given - Set max price to exact Audi price
        let filters = Filters(promptText: "", minPrice: 0, maxPrice: 71320)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 3, "Should return Mercedes, BMW, and Audi (below or at max price)")
        let prices = result.map { $0.price }.sorted()
        XCTAssertEqual(prices, [54891, 63450, 71320])
    }
    
    // MARK: - Data Integrity Tests
    
    func testFetchCars_AllCarsHaveValidUUIDs() {
        // Given
        let filters = Filters(promptText: "", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 6)
        for car in result {
            XCTAssertFalse(car.id.uuidString.isEmpty, "Each car should have a valid UUID")
        }
    }
    
    func testFetchCars_AllCarsHaveValidImageNames() {
        // Given
        let filters = Filters(promptText: "", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 6)
        let expectedImageNames = ["mercedes", "bmw", "audi", "porshe", "tesla", "lexus"]
        for car in result {
            XCTAssertTrue(expectedImageNames.contains(car.imageName), 
                         "Car image name '\(car.imageName)' should be in expected list")
        }
    }
    
    func testFetchCars_AllCarsHavePositivePrices() {
        // Given
        let filters = Filters(promptText: "", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 6)
        for car in result {
            XCTAssertGreaterThan(car.price, 0, "Each car should have a positive price")
        }
    }
    
    func testFetchCars_AllCarsHaveNonEmptyTitles() {
        // Given
        let filters = Filters(promptText: "", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 6)
        for car in result {
            XCTAssertFalse(car.title.isEmpty, "Each car should have a non-empty title")
        }
    }
    
    // MARK: - Performance and Consistency Tests
    
    func testFetchCars_ReturnsConsistentResults() {
        // Given
        let filters = Filters(promptText: "BMW", minPrice: 0, maxPrice: 200000)
        
        // When
        let result1 = mockCarService.fetchCars(filters: filters)
        let result2 = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result1.count, result2.count, "Should return consistent results")
        XCTAssertEqual(result1.first?.id, result2.first?.id, "Should return same car ID")
        XCTAssertEqual(result1.first?.title, result2.first?.title, "Should return same car title")
    }
    
    func testFetchCars_MultipleCallsReturnSameData() {
        // Given
        let filters = Filters(promptText: "", minPrice: 0, maxPrice: 200000)
        
        // When
        let result1 = mockCarService.fetchCars(filters: filters)
        let result2 = mockCarService.fetchCars(filters: filters)
        let result3 = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result1.count, result2.count)
        XCTAssertEqual(result2.count, result3.count)
        XCTAssertEqual(result1.count, 6, "Should consistently return all 6 cars")
    }
    
    // MARK: - Special Character and Unicode Tests
    
    func testFetchCars_WithSpecialCharactersInPrompt_HandlesGracefully() {
        // Given
        let filters = Filters(promptText: "M5-Competition", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should handle special characters gracefully")
    }
    
    func testFetchCars_WithNumbersInPrompt_ReturnsMatchingCars() {
        // Given
        let filters = Filters(promptText: "2021", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 2, "Should return Mercedes and Audi from 2021")
        let titles = result.map { $0.title }
        XCTAssertTrue(titles.contains("Mercedes-Benz 2021 Grand Coupe"))
        XCTAssertTrue(titles.contains("Audi RS7 Sportback 2021"))
    }
    
    // MARK: - Filters Protocol Conformance Tests
    
    func testMockCarService_ConformsToCarServiceProtocol() {
        // Given
        let service: CarService = MockCarService()
        let filters = Filters(promptText: "", minPrice: 0, maxPrice: 200000)
        
        // When
        let result = service.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 6, "MockCarService should conform to CarService protocol")
    }
}

// MARK: - Test Helpers

extension CarServiceTests {
    
    func createFilters(prompt: String = "", min: Int = 0, max: Int = 200000) -> Filters {
        return Filters(promptText: prompt, minPrice: min, maxPrice: max)
    }
    
    func assertCarExists(in cars: [Car], withTitle title: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(cars.contains { $0.title == title }, 
                     "Expected to find car with title '\(title)'", 
                     file: file, line: line)
    }
    
    func assertCarDoesNotExist(in cars: [Car], withTitle title: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(cars.contains { $0.title == title }, 
                      "Expected NOT to find car with title '\(title)'", 
                      file: file, line: line)
    }
}