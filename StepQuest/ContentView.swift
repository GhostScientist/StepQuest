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
    
    @AppStorage("stepGoal") private var stepGoalAppStorage = 10000
    
    // Changed from @AppStorage to @State for manual handling
    @State private var stepGoal = 10000
    @State private var stepsToday = 100

    // iCloud Key-Value Store methods
    func saveStepGoalToiCloud(_ stepGoal: Int) {
        print("@D Saving stepgoal to iCloud \(stepGoal)")
        let store = NSUbiquitousKeyValueStore.default
        store.set(stepGoal, forKey: "stepGoal")
        store.synchronize()
    }

    func fetchStepGoalFromiCloud() -> Int {
        let store = NSUbiquitousKeyValueStore.default
        if let stepGoal = store.object(forKey: "stepGoal") as? Int {
            print("@D Retrieved step goal from iCloud: \(stepGoal)")
            return stepGoal
        } else {
            return 10000 // Default value if not set
        }
    }
    
    
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
                .onChange(of: stepGoal) {
                    saveStepGoalToiCloud(stepGoal)
                }
        }
        .padding()
        .onAppear {
            stepGoal = fetchStepGoalFromiCloud()
            fetchCurrentSteps()
        }
    }
}

#Preview {
    ContentView()
}
