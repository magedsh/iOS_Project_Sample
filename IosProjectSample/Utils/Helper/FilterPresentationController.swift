//
//  FilterPresentationController.swift
//  LaowaiQuestions
//
//  Created by Macbook on 16/04/2023.
//  Copyright © 2023 Maged Shaheen. All rights reserved.
//

import Foundation
class FilterPresentationController: UIPresentationController {
  // MARK: Properties
  
  let blurEffectView: UIVisualEffectView!
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
  // 1.
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
      let blurEffect = UIBlurEffect(style: .dark)
      blurEffectView = UIVisualEffectView(effect: blurEffect)
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  // 2.
  override var frameOfPresentedViewInContainerView: CGRect {
      CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4),
             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
              0.6))
  }

  // 3.
  override func presentationTransitionWillBegin() {
      self.blurEffectView.alpha = 0
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0.7
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
  }
  
  // 4.
  override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.removeFromSuperview()
      })
  }
  
  // 5.
  override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews() 
//      presentedView!.roundCorner(corners: [.topLeft, .topRight], radius: 22)
  }

  // 6.
  override func containerViewDidLayoutSubviews() {
      super.containerViewDidLayoutSubviews()
      presentedView?.frame = frameOfPresentedViewInContainerView
      blurEffectView.frame = containerView!.bounds
  }

  // 7.
  @objc func dismissController(){
      self.presentedViewController.dismiss(animated: true, completion: nil)
  }
}
