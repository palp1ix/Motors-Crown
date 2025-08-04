//
//  CarServiceTests.swift
//  SwiftUI App Tests
//
//  Created by Test Generator
//

import XCTest
@testable import Crown_Motors

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
        let filters = createFilters()
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 6, "Should return all 6 cars when no filters applied")
        assertCarExists(in: result, withTitle: "Mercedes-Benz 2021 Grand Coupe")
        assertCarExists(in: result, withTitle: "BMW M5 Competition 2022")
    }
    
    func testFetchCars_WithValidPromptText_ReturnsMatchingCars() {
        // Given
        let filters = createFilters(prompt: "BMW")
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return only BMW car")
        XCTAssertEqual(result.first?.title, "BMW M5 Competition 2022")
    }
    
    func testFetchCars_WithCaseInsensitivePrompt_ReturnsMatchingCars() {
        // Given
        let filters = createFilters(prompt: "mercedes")
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return Mercedes car with case-insensitive search")
        XCTAssertEqual(result.first?.title, "Mercedes-Benz 2021 Grand Coupe")
    }
    
    func testFetchCars_WithUppercasePrompt_ReturnsMatchingCars() {
        // Given
        let filters = createFilters(prompt: "TESLA")
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return Tesla car with uppercase search")
        XCTAssertEqual(result.first?.title, "Tesla Model S Plaid 2023")
    }
    
    func testFetchCars_WithPriceRangeFiltering_ReturnsCorrectCars() {
        // Given
        let filters = createFilters(min: 60000.0, max: 80000.0)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 2, "Should return BMW and Audi cars in price range")
        assertCarExists(in: result, withTitle: "BMW M5 Competition 2022")
        assertCarExists(in: result, withTitle: "Audi RS7 Sportback 2021")
    }
    
    func testFetchCars_WithCombinedFilters_ReturnsCorrectCars() {
        // Given
        let filters = createFilters(prompt: "2022", max: 70000.0)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return only BMW M5 2022")
        XCTAssertEqual(result.first?.title, "BMW M5 Competition 2022")
    }
    
    // MARK: - Edge Cases
    
    func testFetchCars_WithEmptyPromptAndNarrowPriceRange_ReturnsFilteredCars() {
        // Given
        let filters = createFilters(min: 54000.0, max: 55000.0)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return only Mercedes in narrow price range")
        XCTAssertEqual(result.first?.title, "Mercedes-Benz 2021 Grand Coupe")
    }
    
    func testFetchCars_WithPromptNotFound_ReturnsEmptyArray() {
        // Given
        let filters = createFilters(prompt: "Ferrari")
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array for non-existent car brand")
    }
    
    func testFetchCars_WithMaxPriceLowerThanAllCars_ReturnsEmptyArray() {
        // Given
        let filters = createFilters(max: 10000.0)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array when max price too low")
    }
    
    func testFetchCars_WithMinPriceHigherThanAllCars_ReturnsEmptyArray() {
        // Given
        let filters = createFilters(min: 150000.0)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array when min price too high")
    }
    
    func testFetchCars_WithMinPriceEqualToMaxPrice_ReturnsEmptyArray() {
        // Given
        let filters = createFilters(min: 60000.0, max: 60000.0)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array when min equals max price")
    }
    
    func testFetchCars_WithWhitespaceOnlyPrompt_TreatsAsEmptyPrompt() {
        // Given
        let filters = createFilters(prompt: "   ")
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array for whitespace-only prompt")
    }
    
    func testFetchCars_WithPartialModelMatch_ReturnsMatchingCars() {
        // Given
        let filters = createFilters(prompt: "Coupe")
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 2, "Should return Mercedes and Lexus coupes")
        assertCarExists(in: result, withTitle: "Mercedes-Benz 2021 Grand Coupe")
        assertCarExists(in: result, withTitle: "Lexus LC 500h Coupe 2022")
    }
    
    // MARK: - Boundary Value Tests
    
    func testFetchCars_WithExactMinPrice_ExcludesCarAtMinPrice() {
        // Given
        let filters = createFilters(min: 63450.0)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        assertCarDoesNotExist(in: result, withTitle: "BMW M5 Competition 2022")
        XCTAssertEqual(result.count, 3, "Should return Audi, Porsche, and Tesla (above min price)")
    }
    
    func testFetchCars_WithExactMaxPrice_IncludesCarBelowMaxPrice() {
        // Given
        let filters = createFilters(max: 71320.0)
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 3, "Should return Mercedes, BMW, and Audi (below or at max price)")
        assertCarExists(in: result, withTitle: "Audi RS7 Sportback 2021")
    }
    
    // MARK: - Data Integrity and Consistency
    
    func testFetchCars_ReturnsConsistentResults() {
        // Given
        let filters = createFilters(prompt: "BMW")
        
        // When
        let result1 = mockCarService.fetchCars(filters: filters)
        let result2 = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result1, result2, "Should return consistent results for identical filters")
    }
    
    // MARK: - Special Character Tests
    
    func testFetchCars_WithNumbersInPrompt_ReturnsMatchingCars() {
        // Given
        let filters = createFilters(prompt: "2021")
        
        // When
        let result = mockCarService.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 2, "Should return Mercedes and Audi from 2021")
        assertCarExists(in: result, withTitle: "Mercedes-Benz 2021 Grand Coupe")
        assertCarExists(in: result, withTitle: "Audi RS7 Sportback 2021")
    }
    
    // MARK: - Protocol Conformance
    
    func testMockCarService_ConformsToCarServiceProtocol() {
        // Given
        let service: CarService = MockCarService()
        let filters = createFilters()
        
        // When
        let result = service.fetchCars(filters: filters)
        
        // Then
        XCTAssertEqual(result.count, 6, "MockCarService should conform to CarService protocol")
    }
}

// MARK: - Test Helpers

extension CarServiceTests {
    func createFilters(prompt: String = "", min: Double = 0.0, max: Double = 200000.0) -> Filters {
        return Filters(selectedCompanies: [], minPrice: min, maxPrice: max, promptText: prompt)
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
