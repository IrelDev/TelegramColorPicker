//
//  ColorPickerView.swift
//  TelegramColorPicker
//
//  Created by Kirill Pustovalov on 03.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

@IBDesignable public class ColorPickerView: UIView, BrightnessPickerDelegate {
    internal weak var delegate: ColorPickerDelegate?
    
    @objc dynamic var color: UIColor = .clear
    
    let circleLayer = CAShapeLayer()
    var circleLocation: CGPoint?
    
    var brightness: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        unitedInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        unitedInit()
    }
    func unitedInit() {
        accessibilityIdentifier = "ColorPickerView"
        clipsToBounds = true
        
        setupCircleLayer()
        setupGestureRecognizer()
    }
    private func setupGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(colorTouched(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 0.0
        gestureRecognizer.allowableMovement = CGFloat.greatestFiniteMagnitude
        
        addGestureRecognizer(gestureRecognizer)
    }
    private func setupCircleLayer() {
        let circle = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: Constants.circleSize, height: Constants.circleSize))
        let path = circle.cgPath
        circleLayer.path = path
        circleLayer.lineWidth = Constants.circleLineWidth
        circleLayer.strokeColor = UIColor.white.cgColor
        
        layer.addSublayer(circleLayer)
    }
    func calculateSaturation(withY y: CGFloat) -> CGFloat {
        let saturation = 1 - y / bounds.height
        
        guard saturation >= Constants.minimumColorValue else { return Constants.minimumColorValue }
        guard saturation <= Constants.maximumColorValue else { return Constants.maximumColorValue }
        
        return saturation
    }
    func calculateHue(withX x: CGFloat) -> CGFloat {
        let hue = x / bounds.width
        
        guard hue >= Constants.minimumColorValue else { return Constants.minimumColorValue }
        guard hue <= Constants.maximumColorValue else { return Constants.maximumColorValue }
        
        return hue
    }
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for demensionY: CGFloat in stride(from: 0.0, to: rect.height, by: Constants.colorElementSize) {
            let saturation = calculateSaturation(withY: demensionY)
            
            for demensionX: CGFloat in stride(from: 0.0 ,to: rect.width, by: Constants.colorElementSize) {
                let hue = calculateHue(withX: demensionX)
                let color = UIColor(hue: hue, saturation: saturation, brightness: Constants.maximumColorValue, alpha: Constants.maximumColorValue)
                
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x: demensionX, y: demensionY, width: Constants.colorElementSize, height: Constants.colorElementSize))
            }
        }
        moveCircleToInitialPosition()
    }
    func moveCircleToInitialPosition() {
        let colorAtInitialCirclePoint = getColorAtPoint(point: center)
        self.color = colorAtInitialCirclePoint
        
        moveCircle(to: center, with: color.cgColor)
        delegate?.colorTouched(sender: nil, withColor: color, atPoint: center)
    }
    func moveCircle(to position: CGPoint, with color: CGColor) {
        circleLocation = position
        let newCirclePosition = calculateNewCirclePosition(withPosition: position)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        circleLayer.position = newCirclePosition
        circleLayer.fillColor = color
        
        CATransaction.commit()
    }
    func calculateNewCirclePosition(withPosition position: CGPoint) -> CGPoint {
        let shapeBounds = Constants.circleSize + Constants.circleLineWidth
        
        let offset = shapeBounds / 2
        
        let positionX = position.x
        let positionY = position.y
        
        var newPositionX: CGFloat
        var newPositionY: CGFloat
        
        if shouldRespondToXPoint(x: positionX, offset: offset) {
            newPositionX = positionX - offset
        } else if positionX > bounds.width - shapeBounds {
            newPositionX = bounds.width - shapeBounds
        } else {
            newPositionX = Constants.circleLineWidth
        }
        
        if shouldRespondToYPoint(y: positionY, offset: offset) {
            newPositionY = positionY - offset
        } else if positionY > bounds.height - shapeBounds {
            newPositionY = bounds.height - shapeBounds
        } else {
            newPositionY = Constants.circleLineWidth
        }
        
        let newPosition = CGPoint(x: newPositionX, y: newPositionY)
        return newPosition
    }
    func shouldRespondToXPoint(x: CGFloat, offset: CGFloat) -> Bool {
        x - offset - Constants.circleLineWidth > 0 && x + offset < bounds.width
    }
    func shouldRespondToYPoint(y: CGFloat, offset: CGFloat) -> Bool {
        y - offset - Constants.circleLineWidth > 0 && y + offset < bounds.height
    }
    @objc func colorTouched(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == .began || gestureRecognizer.state == .changed) {
            let pointFromGestureRecognizer = gestureRecognizer.location(in: self)
            
            let colorAtPoint = getColorAtPoint(point: pointFromGestureRecognizer)
            let colorWithBrightness = colorAtPoint.setBrightness(withBrightness: brightness)
            color = colorWithBrightness
            
            moveCircle(to: pointFromGestureRecognizer, with: colorWithBrightness.cgColor)
            
            delegate?.colorTouched(sender: self, withColor: colorAtPoint, atPoint: pointFromGestureRecognizer)
        }
    }
    private func getColorAtPoint(point: CGPoint) -> UIColor {
        let hue = calculateHue(withX: point.x)
        let saturation = calculateSaturation(withY: point.y)
        
        return UIColor(hue: hue, saturation: saturation, brightness: Constants.maximumColorValue, alpha: Constants.maximumColorValue)
    }
    public func brightnessValueChanged(withValue value: Float) {
        brightness = CGFloat(value)
        guard let location = circleLocation else { return }
        let circleColor = getColorAtPoint(point: location)
        
        let colorWithBrightness = circleColor.setBrightness(withBrightness: brightness)
        circleLayer.fillColor = colorWithBrightness.cgColor
        
        color = colorWithBrightness
    }
}
