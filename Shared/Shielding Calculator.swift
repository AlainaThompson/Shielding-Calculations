//
//  Shielding Calculator.swift
//  Shielding Calculations
//
//  Created by Alaina Thompson on 2/4/22.
//

import SwiftUI


class ShieldEq: NSObject,ObservableObject {
    @MainActor @Published var dataPoint = [(xPos: Double, yPos: Double)]()
    @MainActor @Published var endPoints = [(xPos: Double, yPos: Double)]()
    @Published var numberOfParticles = 0
    @Published var percentEscape = 0.0
    @Published var numberEscape = 0
    @Published var percentEscapeText = ""
    @Published var numberEscapeText = ""
    @Published var NString = "10.0"
    var startingPoint = 4.0
    var l = 0
    var yPos = 4.0
    var xPos = 0.0
    var newYPos = 0.0
    var energyLoss = 10
    var maxN = 100
    @Published var enableButton = true
    
    
    @MainActor init(withData data: Bool){
            
            super.init()
            
            endPoints = []
            dataPoint = []
            
        }
    
    
    func initWithDecay(N: Int) async -> Bool {
        await updateNumberOfParticles(maxN: maxN)
        
               let _ = await withTaskGroup(of:  Void.self) { taskGroup in
                   
           
               
                   taskGroup.addTask { let _ = await self.calculateWalk()}
               
           }
               
               await setButtonEnable(state: true)
                                                    
          
           

           return true
           
       }


    func calculateWalk() async -> Double {
        
        var scatterPoints: [(xPos: Double, yPos: Double)] = []
        var endPoints: [(xPos: Double, yPos: Double)] = []
        while l <= maxN {
                    
            var point = (xPos: 0.0, yPos: 4.0)
            
            //
            // mean free path = 1 = squrt(x^2 + y^2)
            //
            // randomize y coordinate while x follows this equation
            for _ in stride(from: 100, to: 0, by: -energyLoss) {
                if point.xPos <= 5.0 && point.yPos <= 5.0 && point.yPos >= 0.0 {
                
                    
                    newYPos = Double.random(in: -1.0...1.0)
                    point.yPos += newYPos
                    let upDown = [-1.0, 1.0]
                    let randomDirection = upDown.randomElement()!
                    point.xPos += randomDirection*sqrt(1 - pow(newYPos, 2))
                    scatterPoints.append(point)
           
                }
            
                else {
                    await self.updateNumberEscape(number: numberEscape)
                    endPoints.append(point)
                    point.xPos = 0.0
                    point.yPos = 4.0
                }
            }
                
        l += 1
        }
        await updatePercentEscape(numberEscape: numberEscape, maxN: maxN)
        
            
        let newPercentEscapeText = String(format: "%7.5f", percentEscape)
        let newNumberEscapeText = String(format: "%7.5f", numberEscape)
        await updateNumberEscape(numberEscapeTextString: newNumberEscapeText)
        await updatePercentEscapeText(percentEscapeTextString: newPercentEscapeText)
        await newNumberEscapeValue(numberEscapeValue: numberEscape)
        await newPercentEscapeValue(percentEscapeValue: percentEscape)
        let plotEndPoints = endPoints
        await updateData(endPoints: plotEndPoints)
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


@MainActor func updatePercentEscapeText(percentEscapeTextString:String){
    
    percentEscapeText = percentEscapeTextString
    
    
}


    @MainActor func updateNumberOfParticles(maxN:Int){
            
        numberOfParticles = maxN
            
        }
        
    @MainActor func updatePercentEscape(numberEscape: Int, maxN:Int){
            
        percentEscape = Double(numberEscape)/(Double(maxN)/100.0)
            
        }
    
    @MainActor func updateNumberEscape(number: Int){
            
        numberEscape = number+1
            
        }
    
    @MainActor func updateData(endPoints: [(xPos: Double, yPos: Double)]) {
            
            dataPoint.append(contentsOf: endPoints)
            
        }
        
}
