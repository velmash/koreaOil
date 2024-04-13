//
//  UIImage+Extention.swift
//  KoreaOil
//
//  Created by 윤형찬 on 2/21/24.
//

import UIKit

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas).image { _ in
            draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func withTintColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let rect = CGRect(origin: .zero, size: size)
        context.clip(to: rect, mask: cgImage!)
        color.setFill()
        context.fill(rect)
        
        guard let tintedImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return tintedImage
    }
}

