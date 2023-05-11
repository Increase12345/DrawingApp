//
//  TopBarView.swift
//  DrawingApp
//
//  Created by Nick Pavlov on 5/11/23.
//

import SwiftUI

struct TopBarView: View {
    @Binding var selectedColor: Color
    @Binding var selectedLineWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 30) {
            ColorPicker("Line Color", selection: $selectedColor)
                .labelsHidden()
            Slider(value: $selectedLineWidth, in: 1...20) {
                Text("linewidth")
            }
            .frame(maxWidth: 150)
            Text(String(format: "%.0f", selectedLineWidth))
        }
        .padding(.top)
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView(selectedColor: .constant(.red), selectedLineWidth: .constant(5))
    }
}
