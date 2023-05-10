//
//  DrawingView.swift
//  DrawingApp
//
//  Created by Nick Pavlov on 5/10/23.
//

import SwiftUI

struct DrawingView: View {
    @State private var lines = [Line(points: [CGPoint(x: 10, y: 10), CGPoint(x: 100, y: 100)], color: .red, lineWidth: 1)]
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 1
    
    
    var body: some View {
        VStack {
            
            ColorPicker("Line Color", selection: $selectedColor)
            Slider(value: $selectedLineWidth, in: 1...20) {
                Text("linewidth")
            }
            
            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    
                    context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        let newPoint = value.location
                        if value.translation.width + value.translation.height == 0 {
                            lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
                        } else {
                            let index =  lines.count - 1
                            lines[index].points.append(newPoint)
                        }
                    })
            )
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
