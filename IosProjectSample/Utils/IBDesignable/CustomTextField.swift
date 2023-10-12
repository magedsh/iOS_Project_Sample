//
//  CustomTextField.swift
//  LaowaiQuestions
//
//  Created by Macbook on 7/15/21.
//  Copyright © 2021 Maged Shaheen. All rights reserved.
//


import Foundation
import UIKit
class CustomTextField:UITextField{

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setProperties()
    }

    func setProperties(){

        backgroundColor = UIColor.white
//        textAlignment = .left
        textColor = .black
        font = UIFont.systemFont(ofSize: 15)
        borderStyle = .roundedRect
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }
    
    
}

class CustomPaddingTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0);

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
