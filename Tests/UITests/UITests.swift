//
//  UITests.swift
//  Tests
//
//  Created by Kirill Pustovalov on 21.08.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import XCTest

class UITests: XCTestCase {
    func testIsTelegramColorPickerExists() {
        let app = XCUIApplication()
        app.launch()
        
        let telegramColorPickerTestable = app.otherElements["TelegramColorPicker"]
        XCTAssertTrue(telegramColorPickerTestable.exists)
    }
    func testIsColorPickerViewExists() {
        let app = XCUIApplication()
        app.launch()
        
        let colorPickerViewTestable = app.otherElements["ColorPickerView"]
        XCTAssertTrue(colorPickerViewTestable.exists)
    }
    func testIsBrightnessSliderViewExists() {
        let app = XCUIApplication()
        app.launch()
        
        let brightnessSliderTestable = app.sliders["BrightnessSliderView"]
        XCTAssertTrue(brightnessSliderTestable.exists)
    }
}
