//
//  ColorPickerDelegate.swift
//  TelegramColorPicker
//
//  Created by Kirill Pustovalov on 03.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: NSObjectProtocol {
    func colorTouched(sender: Any?, withColor color: UIColor, atPoint point: CGPoint)
}
