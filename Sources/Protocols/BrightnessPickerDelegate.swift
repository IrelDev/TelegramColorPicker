//
//  BrightnessPickerDelegate.swift
//  TelegramColorPicker
//
//  Created by Kirill Pustovalov on 03.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

public protocol BrightnessPickerDelegate: NSObjectProtocol {
    func brightnessValueChanged(withValue value: Float)
}
