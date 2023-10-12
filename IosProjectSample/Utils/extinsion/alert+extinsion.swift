//
//  alert+extinsion.swift
//  LaowaiQuestions
//
//  Created by Hakintosh on 03/10/2022.
//  Copyright © 2022 Maged Shaheen. All rights reserved.
//

import Foundation

extension UIViewController{
    func showSimpleAlert(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(Ok)
        self.present(alert, animated: true)
    }
}
extension String {
    func size(with font: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)
        return size
    }
}
extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}
