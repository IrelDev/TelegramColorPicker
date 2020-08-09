//
//  ColorPickerDelegate.swift
//  TelegramColorPicker
//
//  Created by Kirill Pustovalov on 03.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol ColorPickerDelegate: NSObjectProtocol {
    func colorTouched(sender: Any?, withColor color: UIColor, atPoint point: CGPoint)
}
#endif
