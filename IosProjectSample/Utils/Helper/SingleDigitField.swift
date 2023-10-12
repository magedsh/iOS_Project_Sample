//
//  SingleDigitField.swift
//  LaowaiQuestions
//
//  Created by Macbook on 28/11/2021.
//  Copyright © 2021 Maged Shaheen. All rights reserved.
//

import Foundation
import UIKit

class SingleDigitField: UITextField {
    // create a boolean property to hold the deleteBackward info
    var pressedDelete = false
    // customize the text field as you wish
    override func willMove(toSuperview newSuperview: UIView?) {
        keyboardType = .numberPad
        textAlignment = .center
        backgroundColor = .blue
        isSecureTextEntry = true
        isUserInteractionEnabled = false
    }
    // hide cursor
    override func caretRect(for position: UITextPosition) -> CGRect { .zero }
    // hide selection
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { [] }
    // disable copy paste
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool { false }
    // override deleteBackward method, set the property value to true and send an action for editingChanged
    override func deleteBackward() {
        pressedDelete = true
        sendActions(for: .editingChanged)
    }
}
