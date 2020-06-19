//
//  QRCodeBuilder.swift
//  Example
//
//  Created by Kirill Pustovalov on 04.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import Foundation
import UIKit

class QRCodeBuilder {
    var backgroundColor: UIColor = .clear
    var foregroundColor: UIColor = .label
    
    var text: String = "example.com"
    var image: UIImage?
    
    init() { }
    
    func setQRCodeText(with text: String) {
        self.text = text
    }
    func setBackgroundColor(with color: UIColor) {
        self.backgroundColor = color
    }
    func setForegroundColor(with color: UIColor) {
        self.foregroundColor = color
    }
    private func setImageFromText() {
        let data = text.data(using: String.Encoding.isoLatin1)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return }
        filter.setValue(data, forKey: "inputMessage")
        
        guard let coloredFilter = CIFilter(name: "CIFalseColor") else { return }
        coloredFilter.setValue(filter.outputImage, forKey: "inputImage")
        
        coloredFilter.setValue(CIColor(color: backgroundColor), forKey: "inputColor1")
        coloredFilter.setValue(CIColor(color: foregroundColor), forKey: "inputColor0")
        
        guard let image = coloredFilter.outputImage else { return }
        self.image = UIImage(ciImage: image)
    }
    func buildQRCode() -> QRCode {
        setImageFromText()
        
        return QRCode(backgroundColor: backgroundColor, foregroundColor: foregroundColor, text: text, image: image!)
    }
}

