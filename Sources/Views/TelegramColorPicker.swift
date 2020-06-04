//
//  TelegramColorPicker.swift
//  TelegramColorPicker
//
//  Created by Kirill Pustovalov on 03.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class TelegramColorPicker: UIView {
    private let colorPicker = ColorPickerView()
    private let brightnessPicker = BrightnessSlider()
    
    private var observation: NSKeyValueObservation?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        unitedInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        unitedInit()
    }
    func unitedInit() {
        clipsToBounds = true
        backgroundColor = .white

        addViews()
    }
    public func getColorUpdate(update: @escaping (ColorPickerView?, NSKeyValueObservedChange<UIColor>) -> Void) {
        observation = colorPicker.observe(\.color, options: [.old, .new], changeHandler: update)
    }
    private func addViews() {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        colorPicker.delegate = brightnessPicker
        stackView.addArrangedSubview(colorPicker)
        
        let colorPickerWidthConstraint: NSLayoutConstraint = colorPicker.widthAnchor.constraint(equalToConstant: bounds.width)
        
        colorPickerWidthConstraint.priority = UILayoutPriority(rawValue: 999)
        colorPickerWidthConstraint.isActive = true
        
        brightnessPicker.delegate = colorPicker
        stackView.addArrangedSubview(brightnessPicker)
        
        brightnessPicker.translatesAutoresizingMaskIntoConstraints = false
        brightnessPicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        brightnessPicker.widthAnchor.constraint(equalToConstant: bounds.width / 1.2).isActive = true
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .bottom, multiplier: 1, constant: -25)
        let leadingConstraint = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        addConstraints([bottomConstraint, topConstraint, leadingConstraint, trailingConstraint])
    }
}

