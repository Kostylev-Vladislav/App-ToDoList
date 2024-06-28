//
//  ColorPicker.swift
//  App_ToDoList
//
//  Created by Владислав on 28.06.2024.
//

import SwiftUI

struct GradientSpectrum: View {
    @Binding var selectedColor: Color
    
    @State private var hue: Double = 0.0
    @State private var brightness: Double = 1.0
    
    let gradient = Gradient(colors: [
        .red, .orange, .yellow, .green, .blue, .purple, .red
    ])
    
    var body: some View {
        VStack {
            HStack {
                ColorView(color: $selectedColor)
                    .frame(width: 40, height: 40)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                Text("#\(selectedColor.hexString)")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 10)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing)
                        .frame(height: 50)
                        .cornerRadius(10)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    self.hue = min(max(0, Double(value.location.x / geometry.size.width)), 1)
                                    self.updateColor()
                                }
                        )
                    
                    Circle()
                        .fill(selectedColor)
                        .frame(width: 30, height: 30)
                        .offset(x: CGFloat(self.hue) * geometry.size.width - 15)
                }
                .shadow(radius: 5)
            }
            .frame(height: 50)
            
            Slider(value: $brightness, in: 0...1, step: 0.01)
                .padding()
                .onChange(of: brightness) {
                    self.updateColor()
                }
        }
        .padding()
    }
    
    private func updateColor() {
        self.selectedColor = Color(hue: hue, saturation: 1.0, brightness: brightness)
    }
}

struct ColorView: View {
    @Binding var color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
    }
}

extension Color {
    var hexString: String {
        let components = UIColor(self).cgColor.components
        let r = Int((components?[0] ?? 0) * 255)
        let g = Int((components?[1] ?? 0) * 255)
        let b = Int((components?[2] ?? 0) * 255)
        return String(format: "%02X%02X%02X", r, g, b)
    }
}
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

struct ContentView: View {
    @State private var selectedColor: Color = .red
    
    var body: some View {
        GradientSpectrum(selectedColor: $selectedColor)
    }
}

