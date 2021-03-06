//
//  ContentView.swift
//  Shared
//
//  Created by Alaina Thompson on 2/4/22.
//

import SwiftUI

struct ContentView: View {
    @State var energyLoss = 10
    @State var energyLossString = "10"
    @State var percentEscape = 0.0
    @State var numberOfParticles = 0.0
    @State var totalIntegral = 0.0
    @State var maxN = 100
    @State var NString = "100"
    @State var totalNString = "0"
    @State var percentEscapeText = "0.0"
    @State var percentEscapeTextString = "0.0"
    
    
    
   
    @ObservedObject var shieldModel = ShieldEq(withData: true)
    
  
    var body: some View {
        HStack{
            
            VStack{
                
                VStack(alignment: .center) {
                    Text("Number of Particles")
                        .font(.callout)
                        .bold()
                    TextField("# Particles", text: $NString)
                        .padding()
                }
                .padding(.top, 5.0)
                
                VStack(alignment: .center) {
                    Text("Percent Energy Loss")
                        .font(.callout)
                        .bold()
                    TextField("", text: $energyLossString)
                        .padding()
                }
                
                VStack(alignment: .center) {
                    Text("Percent Escape")
                        .font(.callout)
                        .bold()
                    TextField("# Percent Escape", text: $shieldModel.percentEscapeText)
                        .padding()
                }
                
                
                Button("Calculate", action: {Task.init{await self.calculateDecay()}})
                    .padding()
                    .disabled(shieldModel.enableButton == false)
                
                Button("Clear", action: {self.clear()})
                    .padding(.bottom, 5.0)
                    .disabled(shieldModel.enableButton == false)
                
                if (!shieldModel.enableButton){
                    
                    ProgressView()
                }
                
                
            }
            .padding()
            
           
            drawingView(redLayer:$shieldModel.endPoints, blueLayer:$shieldModel.dataPoint)
                           .padding()
                           .aspectRatio(1, contentMode: .fit)
                           .drawingGroup()
                       // Stop the window shrinking to zero.
                       Spacer()
            
            
        }
    }
    
    
        func calculateDecay() async {
                
                
            shieldModel.setButtonEnable(state: false)
                
            shieldModel.energyLoss = Int(energyLossString)!
                
            shieldModel.numberOfParticles = Int(NString)!
                
            await shieldModel.calculateWalk()
                
                
                
            percentEscapeText = shieldModel.percentEscapeText
                
            shieldModel.setButtonEnable(state: true)
                
            }
        
        
        
        

          
    
    func clear(){
        
        NString = "100"
        totalNString = "0.0"
        shieldModel.dataPoint = []
        shieldModel.endPoints = []
        shieldModel.numberOfParticles = 0
        shieldModel.xPos = 0.0
        shieldModel.yPos = 4.0
        shieldModel.percentEscape = 0.0
        shieldModel.numberEscape = 0
        shieldModel.l = 0
      
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}











