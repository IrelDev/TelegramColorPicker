//
//  BrightnessSliderView.swift
//  TelegramColorPicker
//
//  Created by Kirill Pustovalov on 03.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

#if os(iOS)
import Foundation
import UIKit

@IBDesignable public class BrightnessSlider: UISlider, ColorPickerDelegate {
    internal weak var delegate: BrightnessPickerDelegate?
    
    private var color: UIColor = .clear
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        unitedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        unitedInit()
    }
    func unitedInit() {
        accessibilityIdentifier = "BrightnessSliderView"
        gradientLayer.cornerRadius = 20
        isUserInteractionEnabled = true
        semanticContentAttribute = .forceRightToLeft
        maximumTrackTintColor = .clear
        minimumTrackTintColor = .clear
        value = maximumValue
        
        addTarget(self, action: #selector(brightnessValueChanged), for: .valueChanged)
        setupGradientLayer()
        setupThumbImage()
        
        updateLayer()
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    private func setupGradientLayer() {
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        layer.addSublayer(gradientLayer)
    }
    private func updateLayer() {
        gradientLayer.colors = [color.cgColor, UIColor.black.cgColor]
    }
    private func setupThumbImage() {
        let thumbLayer = CAShapeLayer()
        
        let width = frame.size.width / 8
        let height = frame.size.height * 1.72
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: width / 2, y: 7))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        path.move(to: CGPoint(x: 0, y: height + 7))
        
        path.addLine(to: CGPoint(x: width, y: height + 7))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x:0, y: height + 7))
        
        thumbLayer.path = path

        thumbLayer.fillColor = UIColor.black.cgColor
        let image = thumbLayer.imageFromLayer()
        
        for state: UIControl.State in [.normal, .selected, .application, .reserved] {
            setThumbImage(image, for: state)
        }
    }
    public func colorTouched(sender: Any?, withColor color: UIColor, atPoint point: CGPoint) {
        self.color = color
        updateLayer()
    }
    @objc func brightnessValueChanged() {
        delegate?.brightnessValueChanged(withValue: value)
    }
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool { true }
}
#endif
