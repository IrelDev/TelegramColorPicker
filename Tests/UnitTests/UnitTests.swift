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
        
        let expectedCirclePositionForPositiveXPoint = CGPoint(x: colorPickerView.bounds.width - circleSize, y: circlePositionY - circleHalf)
        
        let positiveOutOfBoundsPoint = CGPoint(x: 1000, y: circlePositionY)
        let exactCirclePositionForPositiveXPoint = colorPickerView.calculateNewCirclePosition(withPosition: positiveOutOfBoundsPoint)
        
        XCTAssertEqual(expectedCirclePositionForPositiveXPoint, exactCirclePositionForPositiveXPoint)
        
        let expectedCirclePositionForNegativeXPoint = CGPoint(x: Constants.circleLineWidth, y: circlePositionY - circleHalf)
        
        let negativeOutOfBoundsPoint = CGPoint(x: -1000, y: circlePositionY)
        let exactCirclePositionForNegativeXPoint = colorPickerView.calculateNewCirclePosition(withPosition: negativeOutOfBoundsPoint)
        
        XCTAssertEqual(expectedCirclePositionForNegativeXPoint, exactCirclePositionForNegativeXPoint)
    }
    func testCirclePositionCalculationsWhenYIsOutOfBounds() {
        let circlePositionX = colorPickerView.circleLocation!.x

        let circleSize = Constants.circleSize + Constants.circleLineWidth
        let circleHalf = (Constants.circleSize + Constants.circleLineWidth) / 2

        let expectedCirclePositionForPositveYPoint = CGPoint(x: circlePositionX - circleHalf, y: colorPickerView.bounds.height - circleSize)

        let positveOutOfBoundsPoint = CGPoint(x: circlePositionX, y: 1000)
        let exactCirclePositionForPositiveYPoint = colorPickerView.calculateNewCirclePosition(withPosition: positveOutOfBoundsPoint)

        XCTAssertEqual(expectedCirclePositionForPositveYPoint, exactCirclePositionForPositiveYPoint)
        
        let expectedCirclePositionForNegativeYPoint = CGPoint(x: circlePositionX - circleHalf, y: Constants.circleLineWidth)
        
        let negativeOutOfBoundsPoint = CGPoint(x: circlePositionX, y: -1000)
        let exactCirclePositionForNegativeYPoint = colorPickerView.calculateNewCirclePosition(withPosition: negativeOutOfBoundsPoint)
        
        XCTAssertEqual(expectedCirclePositionForNegativeYPoint, exactCirclePositionForNegativeYPoint)
    }
    func testShouldRespondToX() {
        let circlePositionX = colorPickerView.circleLocation!.x
        let shapeBounds = Constants.circleSize + Constants.circleLineWidth
        let offset = shapeBounds / 2
        
        let positveOutOfBounds: CGFloat = 1000
        let negativeOutOfBounds: CGFloat = -1000
        
        let correctPoint = circlePositionX
        
        XCTAssertFalse(colorPickerView.shouldRespondToX(x: positveOutOfBounds, offset: offset))
        XCTAssertFalse(colorPickerView.shouldRespondToX(x: negativeOutOfBounds, offset: offset))
        
        XCTAssertTrue(colorPickerView.shouldRespondToX(x: correctPoint, offset: offset))
    }
    func testShouldRespondToY() {
        let circlePositionY = colorPickerView.circleLocation!.y
        let shapeBounds = Constants.circleSize + Constants.circleLineWidth
        let offset = shapeBounds / 2
        
        let positveOutOfBounds: CGFloat = 1000
        let negativeOutOfBounds: CGFloat = -1000
        
        let correctPoint = circlePositionY
        
        XCTAssertFalse(colorPickerView.shouldRespondToY(y: positveOutOfBounds, offset: offset))
        XCTAssertFalse(colorPickerView.shouldRespondToY(y: negativeOutOfBounds, offset: offset))
        
        XCTAssertTrue(colorPickerView.shouldRespondToY(y: correctPoint, offset: offset))
    }
}
