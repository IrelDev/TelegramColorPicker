//
//  QRCodeViewController.swift
//  Example
//
//  Created by Kirill Pustovalov on 04.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit
import TelegramColorPicker

class QRCodeViewController: UIViewController {
    let builder = QRCodeBuilder()
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var qrCodeTextLabel: UILabel!
    
    @IBOutlet weak var hexColorLabel: UILabel!
    @IBOutlet weak var telegramColorPicker: TelegramColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeImageView.layer.magnificationFilter = .nearest
        
        showQRCode(qrcode: builder.buildQRCode())
        
        telegramColorPicker.getColorUpdate { [weak self] (_, color) in
            guard let newColor = color.newValue, let hexadecimalColor = newColor.toHex() else { return }
            self?.builder.foregroundColor = newColor
            self?.hexColorLabel.textColor = newColor
            
            self?.hexColorLabel.text = hexadecimalColor
        }
    }
    func showQRCode(qrcode: QRCode) {
        qrCodeImageView.image = qrcode.image
        qrCodeTextLabel.text = qrcode.text
    }
    @IBAction func setColor(_ sender: Any) {
        let qrCode = builder.buildQRCode()
        showQRCode(qrcode: qrCode)
    }
}

