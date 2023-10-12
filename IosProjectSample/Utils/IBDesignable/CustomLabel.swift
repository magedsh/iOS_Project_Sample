//
//  CustomLabel.swift
//  LaowaiQuestions
//
//  Created by Macbook on 7/18/21.
//  Copyright © 2021 Maged Shaheen. All rights reserved.
//

import UIKit
import ActiveLabel
protocol UILabelTapableLinksDelegate: NSObjectProtocol {
    func tapableLabel(_ label: CustomLabel, didTapUrl url: String, atRange range: NSRange)
}

class CustomLabel: ActiveLabel {

    override var canBecomeFirstResponder: Bool {
        return true
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
//        setup()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPressed(_:))
            )
        )
    }

    // MARK: - Actions

    @objc func handleLongPressed(_ gesture: UILongPressGestureRecognizer) {
        guard let gestureView = gesture.view, let superView = gestureView.superview else {
            return
        }

        let menuController = UIMenuController.shared

        guard !menuController.isMenuVisible, gestureView.canBecomeFirstResponder else {
            return
        }

        gestureView.becomeFirstResponder()
//        self.isHighlighted = true

        menuController.menuItems = [
//            UIMenuItem(
//                title: "Custom Item",
//                action: #selector(handleCustomAction(_:))
//            ),
            UIMenuItem(
                title: "Copy".localize,
                action: #selector(handleCopyAction(_:))
            )
        ]

        menuController.setTargetRect(gestureView.frame, in: superView)
        menuController.setMenuVisible(true, animated: true)
        
    }

    @objc func handleCustomAction(_ controller: UIMenuController) {
        print("Custom action!")
    }

    @objc func handleCopyAction(_ controller: UIMenuController) {
        UIPasteboard.general.string = text ?? ""
//        self.isHighlighted = false
    }
    
    ///=====================================
    
//    private var links: [String: NSRange] = [:]
//    private(set) var layoutManager = NSLayoutManager()
//    private(set) var textContainer = NSTextContainer(size: CGSize.zero)
//    private(set) var textStorage = NSTextStorage() {
//        didSet {
//            textStorage.addLayoutManager(layoutManager)
//        }
//    }
//
//    public weak var delegate: UILabelTapableLinksDelegate?
//
//    public override var attributedText: NSAttributedString? {
//        didSet {
//            if let attributedText = attributedText {
//                textStorage = NSTextStorage(attributedString: attributedText)
//                findLinksAndRange(attributeString: attributedText)
//            } else {
//                textStorage = NSTextStorage()
//                links = [:]
//            }
//        }
//    }
//
//    public override var lineBreakMode: NSLineBreakMode {
//        didSet {
//            textContainer.lineBreakMode = lineBreakMode
//        }
//    }
//
//    public override var numberOfLines: Int {
//        didSet {
//            textContainer.maximumNumberOfLines = numberOfLines
//        }
//    }
//
//
//    private func setup() {
//        isUserInteractionEnabled = true
//        layoutManager.addTextContainer(textContainer)
//        textContainer.lineFragmentPadding = 0
//        textContainer.lineBreakMode = lineBreakMode
//        textContainer.maximumNumberOfLines  = numberOfLines
//    }
//
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        textContainer.size = bounds.size
//    }
//
//    private func findLinksAndRange(attributeString: NSAttributedString) {
//        links = [:]
//        let enumerationBlock: (Any?, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void = { [weak self] value, range, isStop in
//            guard let strongSelf = self else { return }
//            if let value = value {
//                let stringValue = "\(value)"
//                strongSelf.links[stringValue] = range
//            }
//        }
//        attributeString.enumerateAttribute(.link, in: NSRange(0..<attributeString.length), options: [.longestEffectiveRangeNotRequired], using: enumerationBlock)
//        attributeString.enumerateAttribute(.attachment, in: NSRange(0..<attributeString.length), options: [.longestEffectiveRangeNotRequired], using: enumerationBlock)
//    }
//
//    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let locationOfTouch = touches.first?.location(in: self) else {
//            return
//        }
//        textContainer.size = bounds.size
//        let indexOfCharacter = layoutManager.glyphIndex(for: locationOfTouch, in: textContainer)
//        for (urlString, range) in links where NSLocationInRange(indexOfCharacter, range) {
//            delegate?.tapableLabel(self, didTapUrl: urlString, atRange: range)
//            return
//        }
//    }

}
