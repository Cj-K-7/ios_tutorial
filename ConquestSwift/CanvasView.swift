//
//  Canvas.swift
//  ConquestSwift
//
//  Created by changju.kim on 1/10/25.
//
import UIKit

class CanvasView: UIView {
    let dumbAssRatio: Double = 2
    var offsetX: Double = 0
    var color = UIColor.gray
    var strokes: [Stroke] = [] // Store strokes to be drawn
        
    var ratioStrokes: [Stroke] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for stroke in strokes {
            guard let firstPoint = stroke.paths.first else { continue }
            var portionPoints: [CGPoint] = []
            // Set up the stroke style
            context.setLineWidth(CGFloat(1))
            context.setStrokeColor(color.cgColor)

            // Create a path
            let path = UIBezierPath()
            let start = CGPoint(
                x: firstPoint.x / dumbAssRatio - offsetX,
                y: firstPoint.y / dumbAssRatio
            )
            path.move(to: start)
            
            let portionOfStart = CGPoint(
                x: start.x / frame.width,
                y: start.y / frame.height
            )
            
            portionPoints.append(portionOfStart)
            
            for point in stroke.paths.dropFirst() {
                let move = CGPoint(
                    x: point.x / dumbAssRatio - offsetX,
                    y: point.y / dumbAssRatio
                )
                path.addLine(to: move)
                let portionOfMove = CGPoint(
                    x: move.x / frame.width,
                    y: move.y / frame.height
                )
                
                portionPoints.append(portionOfMove)
            }

            let newPortionStroke = stroke.copy(
                paths: portionPoints.map { cgpoint in
                    Path(x: cgpoint.x, y: cgpoint.y, force: nil)
                }
            )
            
            path.stroke()
            
            ratioStrokes.append(newPortionStroke)
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
