//
//  AppDelegate.swift
//  BGLGenerator
//
//  Created by Joakim Sjøhaug on 4/12/21.
//

import Foundation
import SwiftUI
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    static let generateReadingTaskIdentifier = "com.sjohaug.BGLGenerator.generateReading"
    static let generateInterval: Double = 60 * 30
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: AppDelegate.generateReadingTaskIdentifier,
            using: DispatchQueue.global()
        ) { task in
            self.handleAppRefresh(task)
        }
        return true
    }
    
    private func handleAppRefresh(_ task: BGTask) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.addOperation {
            let threshold = BGLDataGenerator.Threshold(min: 3.5, max: 12.0)
            let value = threshold.value()
            let reading = BGLDataGenerator.BGLReading(value: value, date: Date())
            
            HKStore.shared.saveBGLMeasure(reading)
        }
        
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        let lastOperation = queue.operations.last
        lastOperation?.completionBlock = {
            task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
        }
        
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        do {
            let request = BGAppRefreshTaskRequest(identifier: AppDelegate.generateReadingTaskIdentifier)
            request.earliestBeginDate = Date(timeIntervalSinceNow: AppDelegate.generateInterval)
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print(error)
        }
    }
}
