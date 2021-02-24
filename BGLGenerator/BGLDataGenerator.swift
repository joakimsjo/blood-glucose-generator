//
//  BGLDataGenerator_1.swift
//  BGLGenerator
//
//  Created by Joakim Sjøhaug on 2/23/21.
//

import Foundation
import SwiftUI

struct BGLDataGenerator {
    // Generated readings
    var readings: Array<BGLReading> = []
    
    // Threshold to generate readings in
    var threshold: Threshold = Threshold()
    
    // Period to generate readings for
    var period = Period()
    
    // Chance for a reading to be inside the specific range.
    // Defaults to 100%
    var readingIsSuccessfull = 1.00
    
    // The number of readings to create for each day
    var readingsPerDay: Int = 5
    
    // Method that generate BGL readings for inside the specific threshold and date period
    mutating func generateReadings() {
        let nValidReadings = Int(100.0 * readingIsSuccessfull)
        let nInvalidReadings = 100 - nValidReadings
        
        let validReadings = Array<Double>(repeating: 1, count: nValidReadings).map { _ in self.threshold.value() }
        let invalidReadings = Array<Double>(repeating: 1, count: nInvalidReadings).map { _ in self.threshold.invalidValue() }

        let values = validReadings + invalidReadings
        
        var day = self.period.start
        
        self.readings = []
        
        while self.period.range.contains(day) {
            for i in 1...self.readingsPerDay {
                let value = values.randomElement()!
                let reading = BGLReading(value: value, date: Calendar.current.date(bySettingHour: i*2, minute: 0, second: 0, of: day)!)
                readings.append(reading)
            }
            day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
        }
    }
    
    struct Threshold {
        // Minimum value a generated BGL reading can have
        var min: Double = 0.0
        
        // Maximum value a generated BGL reading can have
        var max: Double = 10.0
        
        func value() -> Double {
            return Double.random(in: self.min...self.max)
        }
        
        func invalidValue() -> Double {
            return Double.random(in: self.min-0.5...self.max+0.5)
        }
    }
    
    struct Period {
        // Start date of period to create readings for
        var start: Date = Date()
        
        // End date of period to create readings for
        var end: Date = Date()
        
        // The range to create readings for
        var range: ClosedRange<Date> {
            self.start...self.end
        }
    }
    
    struct BGLReading {
        // Value of BGL Reading
        let value: Double
        
        // Date when BGL reading was created
        let date: Date
    }
}
