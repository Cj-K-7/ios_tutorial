//
//  Color.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/21/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = hex.hasPrefix("#") ? 1 : 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0xFF00) >> 8
        let b = rgbValue & 0xFF

        self.init(
            red: CGFloat(r) / 0xFF,
            green: CGFloat(g) / 0xFF,
            blue: CGFloat(b) / 0xFF,
            alpha: 1
        )
    }
}

func mapAndConvertToHex(_ value: Int) -> String {
    // Map the value from the range 1-32 to the range 0-255
    let mappedValue = Int(Double(value - 1) / 31.0 * 255.0)

    // Convert the mapped value to a hexadecimal string
    let hexString = String(format: "%02X", mappedValue)

    return hexString
}

func colorForNumber(_ number: Int) -> UIColor {
    switch number {
    case 0:
        return UIColor.brown
    case 1:
        return UIColor.green
    case 2:
        return UIColor.red
    case 3:
        return UIColor.yellow
    case 4:
        return UIColor.white
    case 5:
        return UIColor.cyan
    default:
        return UIColor.black // Default color for numbers outside 1-5
    }
}
