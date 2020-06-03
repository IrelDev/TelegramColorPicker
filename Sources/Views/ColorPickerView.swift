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
        let circle = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50))
        let path = circle.cgPath
        circleLayer.path = path
        circleLayer.lineWidth = 5
        circleLayer.strokeColor = UIColor.white.cgColor
        
        layer.addSublayer(circleLayer)
        
        let initialPoint = CGPoint(x: -1000, y: -1000)
        moveCircle(to: initialPoint, with: color.cgColor)
    }
    public override func draw(_ rect: CGRect) {
        rectHeight = rect.height
        let context = UIGraphicsGetCurrentContext()
        
        for demensionY: CGFloat in stride(from: 0.0 ,to: rectHeight, by: Constant.size.rawValue) {
            let saturation = 1 - demensionY / rectHeight
            
            for demensionX: CGFloat in stride(from: 0.0 ,to: rect.width, by: Constant.size.rawValue) {
                let hue = demensionX / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
                
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x: demensionX, y: demensionY, width: Constant.size.rawValue, height: Constant.size.rawValue))
            }
        }
    }
    private func moveCircle(to position: CGPoint, with color: CGColor) {
        circleLocation = position
        
        guard let shapeBounds = circleLayer.path?.boundingBox else { return }
        let offsetX = shapeBounds.width / 2
        let offsetY = shapeBounds.height / 2
        
        let offsetPosition = CGPoint(x: position.x - offsetX, y: position.y - offsetY)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        circleLayer.position = offsetPosition
        circleLayer.fillColor = color
        
        CATransaction.commit()
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
        let saturation = 1 - roundedPoint.y / rectHeight
        
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
