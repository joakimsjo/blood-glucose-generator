//
//  BGLGeneratorApp.swift
//  BGLGenerator
//
//  Created by Joakim Sjøhaug on 2/22/21.
//

import SwiftUI

@main
struct BGLGeneratorApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView().onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
                appDelegate.scheduleAppRefresh()
            })
        }
    }
}
