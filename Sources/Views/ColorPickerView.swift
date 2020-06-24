//
//  ColorPickerView.swift
//  TelegramColorPicker
//
//  Created by Kirill Pustovalov on 03.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

@IBDesignable public class ColorPickerView: UIView, BrightnessPickerDelegate {
    struct Constant {
        static let colorElementSize: CGFloat = 1.0
        static let saturation: CGFloat = 2.0
        static let circleLineWidth: CGFloat = 4.0
        static let circleSize: CGFloat = 40.0
        static let minimumColorValue: CGFloat = 0.0
        static let maximumColorValue: CGFloat = 1.0
    }
    internal weak var delegate: ColorPickerDelegate?
    
    @objc dynamic var color: UIColor = .clear
    
    private let circleLayer = CAShapeLayer()
    private var circleLocation: CGPoint?
    
    private var brightness: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        unitedInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        unitedInit()
    }
    func unitedInit() {
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
        let circle = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: Constant.circleSize, height: Constant.circleSize))
        let path = circle.cgPath
        circleLayer.path = path
        circleLayer.lineWidth = Constant.circleLineWidth
        circleLayer.strokeColor = UIColor.white.cgColor
        
        layer.addSublayer(circleLayer)
    }
    func calculateSaturation(withY y: CGFloat) -> CGFloat {
        let saturation = 1 - y / bounds.height
        
        guard saturation >= Constant.minimumColorValue else { return Constant.minimumColorValue }
        guard saturation <= Constant.maximumColorValue else { return Constant.maximumColorValue }
        
        return saturation
    }
    func calculateHue(withX x: CGFloat) -> CGFloat {
        let hue = x / bounds.width
        
        guard hue >= Constant.minimumColorValue else { return Constant.minimumColorValue }
        guard hue <= Constant.maximumColorValue else { return Constant.maximumColorValue }
        
        return hue
    }
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for demensionY: CGFloat in stride(from: 0.0, to: rect.height, by: Constant.colorElementSize) {
            let saturation = calculateSaturation(withY: demensionY)
            
            for demensionX: CGFloat in stride(from: 0.0 ,to: rect.width, by: Constant.colorElementSize) {
                let hue = calculateHue(withX: demensionX)
                let color = UIColor(hue: hue, saturation: saturation, brightness: Constant.maximumColorValue, alpha: Constant.maximumColorValue)
                
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x: demensionX, y: demensionY, width: Constant.colorElementSize, height: Constant.colorElementSize))
            }
        }
        moveCircleToInitialPosition()
    }
    private func moveCircleToInitialPosition() {
        let colorAtInitialCirclePoint = getColorAtPoint(point: center)
        self.color = colorAtInitialCirclePoint
        
        moveCircle(to: center, with: color.cgColor)
        delegate?.colorTouched(sender: nil, withColor: color, atPoint: center)
    }
    private func moveCircle(to position: CGPoint, with color: CGColor) {
        circleLocation = position
        let newCirclePosition = calculateNewCirclePosition(withPosition: position)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        circleLayer.position = newCirclePosition
        circleLayer.fillColor = color
        
        CATransaction.commit()
    }
    func calculateNewCirclePosition(withPosition position: CGPoint) -> CGPoint {
        let shapeBounds = Constant.circleSize + Constant.circleLineWidth
        
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
            newPositionX = Constant.circleLineWidth
        }
        
        if shouldRespondToYPoint(y: positionY, offset: offset) {
            newPositionY = positionY - offset
        } else if positionY > bounds.height - shapeBounds {
            newPositionY = bounds.height - shapeBounds
        } else {
            newPositionY = Constant.circleLineWidth
        }
        
        let newPosition = CGPoint(x: newPositionX, y: newPositionY)
        return newPosition
    }
    func shouldRespondToXPoint(x: CGFloat, offset: CGFloat) -> Bool {
        x - offset - Constant.circleLineWidth > 0 && x + offset < bounds.width
    }
    func shouldRespondToYPoint(y: CGFloat, offset: CGFloat) -> Bool {
        y - offset - Constant.circleLineWidth > 0 && y + offset < bounds.height
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
        
        return UIColor(hue: hue, saturation: saturation, brightness: Constant.maximumColorValue, alpha: Constant.maximumColorValue)
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
