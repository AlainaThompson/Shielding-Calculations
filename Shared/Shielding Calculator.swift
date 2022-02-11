//
//  Shielding Calculator.swift
//  Shielding Calculations
//
//  Created by Alaina Thompson on 2/4/22.
//

import SwiftUI


class ShieldEq: NSObject,ObservableObject {
    @MainActor @Published var dataPoint = [(xPos: Double, yPos: Double)]()
    @Published var numberOfParticles = 0
    var startingPoint = 4.0
    
    var yPos = 4.0
    var xPos = 0.0
    var newYPos = 0.0
    var energyLoss = 10
    @Published var percentEscape = 0.0
    @Published var numberEscape = 0
    @Published var percentEscapeText = ""
    @Published var numberEscapeText = ""
    @Published var NString = "10.0"
    @Published var maxN = 0
    @Published var enableButton = true
    
    func initWithDecay(N: Int) async -> Bool {
           
           numberOfParticles = N
               
               let _ = await withTaskGroup(of:  Void.self) { taskGroup in
                   
           
               
                   taskGroup.addTask { let _ = await self.calculateWalk(N: self.numberOfParticles)}
               
           }
               
               await setButtonEnable(state: true)
                                                    
          
           

           return true
           
       }


    func calculateWalk(N: Int) async -> Double {
        while N <= maxN {
                    
            var point = (xPos: 0.0, yPos: 0.0)
            var scatterPoints: [(xPos: Double, yPos: Double)] = []
            //
            // mean free path = 1 = squrt(x^2 + y^2)
            //
            // randomize y coordinate while x follows this equation
        
            for _ in stride(from: 100, to: 0, by: energyLoss) {
                newYPos = Double.random(in: 0.0...1.0)
                point.yPos += newYPos
                point.xPos += sqrt(1 - pow(newYPos, 2))
            
                scatterPoints.append(point)
           
                return xPos
            }
            
        
            if point.xPos >= 5.0 {
            
                numberEscape += 1
            
            }
           N += 1
        }
        percentEscape = Double(numberEscape)/(Double(N)/100.0)
            
        let newPercentEscapeText = String(format: "%7.5f", percentEscape)
        let newNumberEscapeText = String(format: "%7.5f", numberEscape)
        await updateNumberEscape(numberEscapeTextString: newNumberEscapeText)
        await updatePercentEscape(percentEscapeTextString: newPercentEscapeText)
        await newNumberEscapeValue(numberEscapeValue: numberEscape)
        await newPercentEscapeValue(percentEscapeValue: percentEscape)
                
        return percentEscape
        
                
    }



@MainActor func setButtonEnable(state: Bool){
    
    
    if state {
        
        Task.init {
            await MainActor.run {
                
                
                self.enableButton = true
            }
        }
        
        
            
    }
    else{
        
        Task.init {
            await MainActor.run {
                
                
                self.enableButton = false
            }
        }
            
    }
    
}


@MainActor func updateNumberEscape(numberEscapeTextString: String){
    
    numberEscapeText = numberEscapeTextString
    
}

@MainActor func newNumberEscapeValue(numberEscapeValue: Int){
    
    self.numberEscape = numberEscapeValue
    
}

@MainActor func newPercentEscapeValue(percentEscapeValue: Double){
    
    self.percentEscape = percentEscapeValue
    
}


@MainActor func updatePercentEscape(percentEscapeTextString:String){
    
    percentEscapeText = percentEscapeTextString
    
    
}





}
