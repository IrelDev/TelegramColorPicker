//
//  CAShapeLayer.swift
//  TelegramColorPicker
//
//  Created by Kirill Pustovalov on 03.06.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

#if os(iOS)
import UIKit

extension CAShapeLayer {
    func imageFromLayer() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.path!.boundingBox.size,
                                               self.isOpaque, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        self.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
#endif
