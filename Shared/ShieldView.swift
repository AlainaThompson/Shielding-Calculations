//
//  ShieldView.swift
//  Shielding Calculations
//
//  Created by Alaina Thompson on 2/15/22.
//

import SwiftUI

struct drawingView: View {
    
    @Binding var redLayer : [(xPos: Double, yPos: Double)]
    @Binding var blueLayer : [(xPos: Double, yPos: Double)]
    
    var body: some View {
    
        
        ZStack{
        
            drawIntegral(drawingPoints: redLayer )
                .stroke(Color.red)
            
            drawIntegral(drawingPoints: blueLayer )
                .stroke(Color.blue)
        }
        .background(Color.white)
        .aspectRatio(1, contentMode: .fill)
        
    }
}

struct DrawingView_Previews: PreviewProvider {
    
    @State static var redLayer : [(xPos: Double, yPos: Double)] = [(-0.5, 0.5), (0.5, 0.5), (0.0, 0.0), (0.0, 1.0)]
    @State static var blueLayer : [(xPos: Double, yPos: Double)] = [(-0.5, -0.5), (0.5, -0.5), (0.9, 0.0)]
    
    static var previews: some View {
       
        
        drawingView(redLayer: $redLayer, blueLayer: $blueLayer)
            .aspectRatio(1, contentMode: .fill)
            //.drawingGroup()
           
    }
}



struct drawIntegral: Shape {
    
   
    let smoothness : CGFloat = 1.0
    var drawingPoints: [(xPos: Double, yPos: Double)]  ///Array of tuples
    
    func path(in rect: CGRect) -> Path {
        
               
        // draw from the center of our rectangle
        let center = CGPoint(x: rect.width/1000, y: rect.height)
        let scale = rect.width
        

        // Create the Path for the display
        
        var path = Path()
        
        for item in drawingPoints {
            
            path.addRect(CGRect(x: item.xPos*Double(scale)+Double(center.x), y: item.yPos*Double(-scale)+Double(center.y), width: 1.0 , height: 1.0))
            
        }


        return (path)
    }
}
// Could not figure out how to make display window larger
