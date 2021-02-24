//
//  BGLDataGenerator.swift
//  BGLGeneratorTests
//
//  Created by Joakim Sjøhaug on 2/22/21.
//

import XCTest

class BGLDataGeneratorTests: XCTestCase {
    func testGenerateBGLDataForDay() throws {
        var generator = BGLDataGenerator(readingsPerDay: 10)
        
        // set and assert threshold values
        generator.threshold.max = 5.0
        generator.threshold.min = 4.5
        
        XCTAssertEqual(4.5, generator.threshold.min)
        XCTAssertEqual(5.0, generator.threshold.max)
        
        let endDate = Calendar.current.date(byAdding: .day, value: 4, to: Date() )!
        let startDate = Date()
        
        // set and assert period values
        generator.period.start = startDate
        generator.period.end = endDate
        
        XCTAssertEqual(startDate, generator.period.start)
        XCTAssertEqual(endDate, generator.period.end)
        
        // generate readings
        generator.generateReadings()
        
        XCTAssertEqual(generator.readings.count, 40)
    }
    
    func testGeneratorGeneratesReadingsInsideRange () throws {
        var generator = BGLDataGenerator()
        
        // set threshold
        generator.threshold.min = 4.0
        generator.threshold.max = 5.0
        
        generator.generateReadings()
        
        // assert that 4 redings is created
        XCTAssertEqual(generator.readings.count, 5)
        
        // validate all 4 readings created by generator
        XCTAssertTrue(generator.readings.allSatisfy{ $0.value >= generator.threshold.min && $0.value <= generator.threshold.max})
    }
    
    func testGeneratorSomeValuesOutsideRangeWhenSuccessfullRateIsNotHoundred() throws {
        var generator = BGLDataGenerator(readingIsSuccessfull: 0.5, readingsPerDay: 10)
        
        // set threshold
        generator.threshold.min = 4.0
        generator.threshold.max = 5.0
        
        generator.generateReadings()
        
        XCTAssertFalse(generator.readings.allSatisfy { $0.value >= 4.0 && $0.value <= 5.0 })
    }
    
    func testGeneratorGeneratesReadingsForMultipleDaysWhenPeriodSpansMultipleDates() throws {
        var generator = BGLDataGenerator(readingIsSuccessfull: 0.5, readingsPerDay: 10)
        
        // set threshold
        generator.threshold.min = 4.0
        generator.threshold.max = 5.0
        
        // set period
        generator.period.end = Calendar.current.date(byAdding: .day, value: 4, to: Date())!
        generator.generateReadings()
        
        XCTAssertFalse(generator.readings.allSatisfy { Calendar.current.dateComponents([.day], from: Date(), to: $0.date).day == 0 })
    }
    
    func testGeneratorGenerateReadingsFromMidnight () throws {
        var generator = BGLDataGenerator()
        
        // set threshold
        generator.threshold.min = 4.0
        generator.threshold.max = 5.0
        
        generator.generateReadings()
        
        // assert that 4 redings is created
        XCTAssertEqual(generator.readings.count, 5)
        
        // validate all 4 readings created by generator
        XCTAssertEqual(Calendar.current.component(.hour, from: generator.readings[0].date), 2)
        XCTAssertEqual(Calendar.current.component(.hour, from: generator.readings[1].date), 4)
        XCTAssertEqual(Calendar.current.component(.hour, from: generator.readings[2].date), 6)
        XCTAssertEqual(Calendar.current.component(.hour, from: generator.readings[3].date), 8)
        XCTAssertEqual(Calendar.current.component(.hour, from: generator.readings[4].date), 10)
        
    }
}
