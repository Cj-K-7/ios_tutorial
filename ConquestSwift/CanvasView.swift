//
//  Canvas.swift
//  ConquestSwift
//
//  Created by changju.kim on 1/10/25.
//
import UIKit

class CanvasView: UIView {
    let dumbAssRatio: Double = 2
    let resizeRatio: Double = 4.0
    let offsetX = 834.24 * 0.16
    let size = CGSize(width: 834.24, height: 632)
    var color = UIColor.red
    var strokes: [Stroke] = [] // Store strokes to be drawn
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for stroke in strokes {
            guard let firstPoint = stroke.paths.first else { continue }
            
            // Set up the stroke style
            context.setLineWidth(CGFloat(1))
            context.setStrokeColor(color.cgColor)

            // Create a path
            let path = UIBezierPath()
            let start = CGPoint(
                x: firstPoint.x / dumbAssRatio,
                y: firstPoint.y / dumbAssRatio
            )
            
            path.move(to: start)
            
            for point in stroke.paths.dropFirst() {
                let move = CGPoint(
                    x: point.x / dumbAssRatio,
                    y: point.y / dumbAssRatio
                )
                
                path.addLine(to: move)
            }

            path.stroke()
        }
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
