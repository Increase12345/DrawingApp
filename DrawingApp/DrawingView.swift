//
//  DrawingView.swift
//  DrawingApp
//
//  Created by Nick Pavlov on 5/10/23.
//

import SwiftUI

struct DrawingView: View {
    @State private var lines = [Line]()
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 5
    @State private var deletedLines = [Line]()
    @State private var showConfirmationDialog = false
    let engine = DrawingEngine()
    
    var body: some View {
        VStack {
            
            // Top Bar View
            TopBarView(selectedColor: $selectedColor, selectedLineWidth: $selectedLineWidth)
            Divider()
            
            // Canvas area
            Canvas { context, size in
                for line in lines {
                    let path = engine.createPath(for: line.points)
                    
                    context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
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
                    .onEnded({ value in
                        if let last = lines.last?.points, last.isEmpty {
                            lines.removeLast()
                        }
                    })
            )
            Divider()
            
            // Bottom Bar Buttons
            HStack(spacing: 80) {
                
                // Undo button
                Button {
                        let last = lines.removeLast()
                    deletedLines.append(last)
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .foregroundColor(lines.isEmpty ? .gray: .green)
                }
                .disabled(lines.isEmpty)
                
                
                // Reset All button
                Button {
                    showConfirmationDialog.toggle()
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(lines.isEmpty && deletedLines.isEmpty ? .gray: .red)
                }
                .disabled(lines.isEmpty && deletedLines.isEmpty)
                .confirmationDialog("", isPresented: $showConfirmationDialog) {
                    Button("Delete", role: .destructive) {
                        lines = [Line]()
                        deletedLines = [Line]()
                    }
                } message: {
                    Text("Are you sure you want to delete everything?")
                }
                
                // Redu button
                Button {
                        let last = deletedLines.removeLast()
                        lines.append(last)
                } label: {
                    Image(systemName: "arrow.uturn.forward")
                        .foregroundColor(deletedLines.isEmpty ? .gray: .green)
                }
                .disabled(deletedLines.isEmpty)
            }
            .font(.title)
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
