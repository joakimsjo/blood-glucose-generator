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
    let HKMetaThresholdKey = "Threshold"
    
    fileprivate init() {
        if HKHealthStore.isHealthDataAvailable() {
            healtStore = HKHealthStore()
        } else {
            print("Health store is not available")
        }
    }
    
    
    func saveBGLMeasure(_ data: BGLDataGenerator.BGLReading, _ threshold: String? = nil) {
        let bglType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!
        
        let bglQuantity = HKQuantity(unit: bglUnit, doubleValue: data.value * 18)
        
        // construct reading meta data
        var meta = [String:Any]()
        
        if let thresholdString = threshold {
            meta[HKMetaThresholdKey] = thresholdString
        }
        
        let sample = HKQuantitySample(type: bglType, quantity: bglQuantity, start: data.date, end: data.date, metadata: meta)
        
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
                self.saveBGLMeasure(data, threshold)
            }
        }
    }
}
