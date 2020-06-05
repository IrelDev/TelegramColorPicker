//
//  ColorPickerView.swift
//  TelegramColorPicker
//
//  Created by Kirill Pustovalov on 03.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

@IBDesignable public class ColorPickerView: UIView, BrightnessPickerDelegate {
    enum Constant: CGFloat {
        case size = 1.0
        case saturation = 2.0
        case circleSize = 50
    }
    internal weak var delegate: ColorPickerDelegate?
    
    @objc dynamic var color: UIColor = .clear
    
    private let circleLayer = CAShapeLayer()
    private var circleLocation: CGPoint?
    private var rectHeight: CGFloat!
    
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
        let circle = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: Constant.circleSize.rawValue, height: Constant.circleSize.rawValue))
        let path = circle.cgPath
        circleLayer.path = path
        circleLayer.lineWidth = 5
        circleLayer.strokeColor = UIColor.white.cgColor
        
        layer.addSublayer(circleLayer)
    }
    func calculateSaturation(withY y: CGFloat) -> CGFloat {
        let saturation = 1 - y / rectHeight
        
        guard saturation >= 0 else { return 0 }
        guard saturation <= 1 else { return 1 }
        
        return saturation
    }
    public override func draw(_ rect: CGRect) {
        rectHeight = rect.height
        let context = UIGraphicsGetCurrentContext()
        
        for demensionY: CGFloat in stride(from: 0.0 ,to: rectHeight, by: Constant.size.rawValue) {
            let saturation = calculateSaturation(withY: demensionY)
            
            for demensionX: CGFloat in stride(from: 0.0 ,to: rect.width, by: Constant.size.rawValue) {
                let hue = demensionX / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
                
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x: demensionX, y: demensionY, width: Constant.size.rawValue, height: Constant.size.rawValue))
            }
        }
        moveCircleToInitialPosition()
    }
    private func moveCircleToInitialPosition() {
        let initialCirclePoint = CGPoint(x: center.x, y: center.y)
        let colorAtInitialCirclePoint = getColorAtPoint(point: initialCirclePoint)
        self.color = colorAtInitialCirclePoint
        
        moveCircle(to: initialCirclePoint, with: color.cgColor)
        circleLocation = circleLayer.position
        delegate?.colorTouched(sender: nil, withColor: color, atPoint: initialCirclePoint)
    }
    private func moveCircle(to position: CGPoint, with color: CGColor) {
        guard let shapeBounds = circleLayer.path?.boundingBox else { return }
        let offsetX = shapeBounds.width / 2
        let offsetY = shapeBounds.height / 2
        
        var newPositionX: CGFloat
        var newPositionY: CGFloat
        
        if shouldRespondToXPoint(x: position.x, offsetX: offsetX) {
            newPositionX = position.x - offsetX
        } else {
            newPositionX = circleLayer.position.x
        }
        if shouldRespondToYPoint(y: position.y, offsetY: offsetY) {
            newPositionY = position.y - offsetY
        } else {
            newPositionY = circleLayer.position.y
        }
        
        let newPosition = CGPoint(x: newPositionX, y: newPositionY)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        circleLayer.position = newPosition
        circleLayer.fillColor = color
        
        CATransaction.commit()
    }
    func shouldRespondToXPoint(x: CGFloat, offsetX: CGFloat) -> Bool {
        x - offsetX > 0 && x + offsetX < bounds.width
    }
    func shouldRespondToYPoint(y: CGFloat, offsetY: CGFloat) -> Bool {
        y - offsetY > 0 && y + offsetY < bounds.height
    }
    @objc func colorTouched(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == .began || gestureRecognizer.state == .changed) {
            let pointFromGestureRecognizer = gestureRecognizer.location(in: self)
            
            let colorAtPoint = getColorAtPoint(point: pointFromGestureRecognizer)
            let color = colorAtPoint.setBrightness(withBrightness: brightness)
            self.color = color
            
            moveCircle(to: pointFromGestureRecognizer, with: color.cgColor)
            
            delegate?.colorTouched(sender: self, withColor: colorAtPoint, atPoint: pointFromGestureRecognizer)
        }
    }
    private func getColorAtPoint(point: CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x: Constant.size.rawValue * CGFloat(Int(point.x / Constant.size.rawValue)),
                                   y: Constant.size.rawValue * CGFloat(Int(point.y / Constant.size.rawValue)))
        let y = roundedPoint.y
        let saturation = calculateSaturation(withY: y)
        
        let hue = roundedPoint.x / bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
    }
    func brightnessValueChanged(withValue value: Float) {
        brightness = CGFloat(value)
        guard let location = circleLocation else { return }
        let circleColor = getColorAtPoint(point: location)
        
        let color = circleColor.setBrightness(withBrightness: brightness)
        circleLayer.fillColor = color.cgColor
        
        self.color = color
    }
}
