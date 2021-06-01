
//
//  FormViewModel.swift
//  BGLGenerator
//
//  Created by Joakim Sjøhaug on 2/23/21.
//

import Foundation
import SwiftUI

class FormViewModel: ObservableObject {
    @Published
    var bglGenerator: BGLDataGenerator = BGLDataGenerator(threshold: BGLDataGenerator.Threshold(min: 4.0, max: 10.0))
    
    @Published
    var readingsGenerated: Bool = false
    
    var numberOfReadings = [1, 3, 5, 10, 15]
    
    // MARK: - Intents
    func generateReadings() {
        self.bglGenerator.generateReadings()
        self.bglGenerator.readings.forEach { HKStore.shared.saveBGLMeasure($0, self.bglGenerator.threshold.descriptor) }
        self.readingsGenerated.toggle()
    }
}
