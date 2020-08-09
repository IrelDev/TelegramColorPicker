//
//  Tests.swift
//  Tests
//
//  Created by Kirill Pustovalov on 09.08.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import XCTest
@testable import TelegramColorPicker

class UnitTests: XCTestCase {
    var colorPickerView: ColorPickerView!

    override func setUp() {
        super.setUp()
        colorPickerView = ColorPickerView(frame: CGRect(x: 0, y: 0, width: 400, height: 250))
        colorPickerView.moveCircleToInitialPosition()
    }
    override func tearDown() {
        colorPickerView = nil
        super.tearDown()
    }
    func testIsCircleAtCenterAfterMoveCircleToInitialPosition() {
        XCTAssertEqual(colorPickerView.circleLocation, colorPickerView.center)
    }
    func testCirclePositionCalculationsWhenXIsOutOfBounds() {
        let circlePositionY = colorPickerView.circleLocation!.y
        
        let circleSize = Constants.circleSize + Constants.circleLineWidth
        let circleHalf = (Constants.circleSize + Constants.circleLineWidth) / 2
        
        let expectedCirclePosition = CGPoint(x: colorPickerView.bounds.width - circleSize, y: circlePositionY - circleHalf)
        
        let outOfBoundsPoint = CGPoint(x: 1000, y: circlePositionY)
        let exactCirclePosition = colorPickerView.calculateNewCirclePosition(withPosition: outOfBoundsPoint)
        
        XCTAssertEqual(expectedCirclePosition, exactCirclePosition)
    }
    func testCirclePositionCalculationsWhenXIsNegative() {
        let circlePositionY = colorPickerView.circleLocation!.y
        let circleHalf = (Constants.circleSize + Constants.circleLineWidth) / 2
        
        let expectedCirclePosition = CGPoint(x: Constants.circleLineWidth, y: circlePositionY - circleHalf)
        
        let outOfBoundsPoint = CGPoint(x: -1000, y: circlePositionY)
        let exactCirclePosition = colorPickerView.calculateNewCirclePosition(withPosition: outOfBoundsPoint)
        
        XCTAssertEqual(expectedCirclePosition, exactCirclePosition)
    }
    func testCirclePositionCalculationsWhenYIsNegative() {
        let circlePositionX = colorPickerView.circleLocation!.x
        let circleHalf = (Constants.circleSize + Constants.circleLineWidth) / 2
        
        let expectedCirclePosition = CGPoint(x: circlePositionX - circleHalf, y: Constants.circleLineWidth)
        
        let outOfBoundsPoint = CGPoint(x: circlePositionX, y: -1000)
        let exactCirclePosition = colorPickerView.calculateNewCirclePosition(withPosition: outOfBoundsPoint)
        
        XCTAssertEqual(expectedCirclePosition, exactCirclePosition)
    }
    func testCirclePositionCalculationsWhenYIsOutOfBounds() {
        let circlePositionX = colorPickerView.circleLocation!.x
        
        let circleSize = Constants.circleSize + Constants.circleLineWidth
        let circleHalf = (Constants.circleSize + Constants.circleLineWidth) / 2
        
        let expectedCirclePosition = CGPoint(x: circlePositionX - circleHalf, y: colorPickerView.bounds.height - circleSize)
        
        let outOfBoundsPoint = CGPoint(x: circlePositionX, y: 1000)
        let exactCirclePosition = colorPickerView.calculateNewCirclePosition(withPosition: outOfBoundsPoint)
        
        XCTAssertEqual(expectedCirclePosition, exactCirclePosition)
    }
}
