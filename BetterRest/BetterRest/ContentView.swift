//
//  ContentView.swift
//  BetterRest
//
//  Created by Anup Deshpande on 10/31/20.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("When do you want to wake up?")
                            .font(.headline)
                            .textCase(.none)){
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                }
                                
                Section(header: Text("Desired amount of sleep")
                            .font(.headline)
                            .textCase(.none)){
                                        
                    Stepper("\(sleepAmount, specifier: "%g")", value: $sleepAmount, in: 4 ... 12, step: 0.25)
                }
                
                Section(header: Text("Daily coffee intake")
                            .font(.headline)
                            .textCase(.none)){

                    Stepper(value: $coffeeAmount, in: 1 ... 20){
                        if coffeeAmount == 1{
                            Text("1 cup")
                        }else{
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
                
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                                    Button(action: calculateBedtime){
                                        Text("Calculate")
                                    }
            )
            .alert(isPresented: $showingAlert){
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime(){
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let min = (components.minute ?? 0) * 60
        
        do{
            let prediction = try model.prediction(wake: Double(hour + min), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            
            alertMessage = dateFormatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is"
            
        }catch{
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        
        showingAlert = true
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
