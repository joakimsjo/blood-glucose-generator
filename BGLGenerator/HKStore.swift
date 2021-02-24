//
//  HKStore.swift
//  BGLGenerator
//
//  Created by Joakim Sjøhaug on 2/24/21.
//

import Foundation
import HealthKit

class HKStore {
    static let shared = HKStore()

    let bglUnit = HKUnit(from: "mg/dL")
    var healtStore: HKHealthStore?
    
    fileprivate init() {
        if HKHealthStore.isHealthDataAvailable() {
            healtStore = HKHealthStore()
        } else {
            print("Health store is not available")
        }
    }
    
    
    func saveBGLMeasure(_ data: BGLDataGenerator.BGLReading) {
        let bglType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!
        
        let bglQuantity = HKQuantity(unit: bglUnit, doubleValue: data.value * 18)
        let sample = HKQuantitySample(type: bglType, quantity: bglQuantity, start: data.date, end: data.date)
        
        self.healtStore?.requestAuthorization(toShare: [bglType], read: nil) { success, error in
            if success {
                self.healtStore?.save(sample) { success, error in
                    if success {
                        print("Saved")
                    } else {
                        print(error!)
                    }
                }
            } else {
                self.saveBGLMeasure(data)
            }
        }
    }
}
