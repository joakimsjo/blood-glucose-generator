//
//  ContentView.swift
//  BGLGenerator
//
//  Created by Joakim Sjøhaug on 2/22/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var formVM: FormViewModel = FormViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("BGL Range mmol/L")) {
                    Stepper("min: \(String(format: "%.1f", formVM.bglGenerator.threshold.min))", value: self.$formVM.bglGenerator.threshold.min, in: 0...formVM.bglGenerator.threshold.max, step: 0.1)
                    Stepper("max: \(String(format: "%.1f", formVM.bglGenerator.threshold.max))", value: self.$formVM.bglGenerator.threshold.max, in: formVM.bglGenerator.threshold.min...10, step: 0.1)
                }
                Section(header: Text("Date range")) {
                    DatePicker(
                        selection: self.$formVM.bglGenerator.period.start,
                        in: ...formVM.bglGenerator.period.end,
                        displayedComponents: .date,
                        label: { Text("Start") }
                    )
                    DatePicker(
                        selection: self.$formVM.bglGenerator.period.end,
                        in: formVM.bglGenerator.period.start...,
                        displayedComponents: .date,
                        label: { Text("End") }
                    )
                }
                
                Section(header: Text("Readings per day")) {
                    VStack {
                        Picker(selection: self.$formVM.bglGenerator.readingsPerDay, label: Text("What is your favorite color?")) {
                            ForEach(self.formVM.numberOfReadings, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Button("Generate readings", action: {
                    self.formVM.generateReadings()
                })
            }
            .navigationBarTitle(Text("BGL Data Generator"))
            .alert(isPresented: self.$formVM.readingsGenerated, content: {
                Alert(title: Text("Readings generated!"))
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
