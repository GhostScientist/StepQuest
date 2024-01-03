//
//  ContentView.swift
//  StepQuest
//
//  Created by Dakota Kim on 12/28/23.
//

import SwiftUI
import HealthKit

extension Date {
    static var startOfDay: Date {
        return Calendar.current.startOfDay(for: Date())
    }
}

struct ContentView: View {
    
    private let healthStore = HKHealthStore()
    
    @AppStorage("stepGoal") private var stepGoal = 10000
    
    @State private var stepsToday = 100
    
    func authorizeHealthKit() {
        let allTypes = Set([
                            HKObjectType.quantityType(forIdentifier: .stepCount)!])


        healthStore.requestAuthorization(toShare: [], read: allTypes) { (success, error) in
            if !success {
                print("Man what the FUCK")
            }
        }
    }
    
    func fetchCurrentSteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                print("Aw fuck shit man")
                return
            }
            
            let numSteps = Int(quantity.doubleValue(for: .count()))
            print("STEP COUNT TODAY: \(numSteps)")
            stepsToday = numSteps
            
        }
        
        healthStore.execute(query)
    }
    
    var body: some View {
        
        VStack {
            Button(action: authorizeHealthKit)  {
                Text("Request HealthKit Auth")
            }
            
            Button(action: fetchCurrentSteps)  {
                Text("Fetch Steps")
            }
            
            Text("NUM STEPS: \(stepsToday)")
            let double1 = Double(stepsToday)
            let double2 = Double(stepGoal)
            ProgressView(value: double1, total: double2)
            Text("USER STEP GOAL: \(stepGoal)")
            Divider()
            TextField("Step Goal", value: $stepGoal, format: .number)
        }
        .padding()
        .onAppear {
            fetchCurrentSteps()
        }
    }
}

#Preview {
    ContentView()
}
