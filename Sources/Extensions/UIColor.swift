//
//  UIColor.swift
//  TelegramColorPicker
//
//  Created by Kirill Pustovalov on 03.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

extension UIColor {
    func setBrightness(withBrightness brightness: CGFloat) -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, currentBrightness: CGFloat = 0, alpha: CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &currentBrightness, alpha: &alpha) {
            currentBrightness += (brightness - 1.0)
            currentBrightness = max(min(brightness, 1.0), 0.0)
            
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        
        return self
    }
    public func toHex() -> String? {
        var unsafeRed: CGFloat = 0.0, unsafeGreen: CGFloat = 0.0, unsafeBlue: CGFloat = 0.0
        getRed(&unsafeRed, green: &unsafeGreen, blue: &unsafeBlue, alpha: nil)
        
        let red = lroundf(Float(unsafeRed) * 255)
        let green = lroundf(Float(unsafeGreen) * 255)
        let blue = lroundf(Float(unsafeBlue) * 255)
        
        return "#\(String(format: "%02lX%02lX%02lX", red, green, blue))"
    }
}
