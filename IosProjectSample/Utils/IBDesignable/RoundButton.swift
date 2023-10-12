//
//  RoundButton.swift
//  LaowaiQuestions
//
//  Created by Macbook on 3/29/21.
//
//

import UIKit
@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius:CGFloat = 0 {
           didSet{
               layer.cornerRadius = cornerRadius
               layer.masksToBounds = cornerRadius > 0
           }
           
       }
       
       @IBInspectable var borderWidth:CGFloat = 0 {
           didSet{
               layer.borderWidth = borderWidth
               
           }
           
       }
       
       @IBInspectable var borderColor:UIColor = .white {
           didSet{
               layer.borderColor = borderColor.cgColor
               
           }
           
       }

}

@IBDesignable
class RoundButtonNew: UIButton {

    @IBInspectable var cornerRadius:CGFloat = 4 {
           didSet{
               layer.cornerRadius = cornerRadius
               layer.masksToBounds = cornerRadius > 0
           }
           
       }
       
       @IBInspectable var borderWidth:CGFloat = 1 {
           didSet{
               layer.borderWidth = borderWidth
               
           }
           
       }
           
       @IBInspectable var borderColor:UIColor = #colorLiteral(red: 0.9294117647, green: 0.9450980392, blue: 0.968627451, alpha: 1) {
           didSet{
               layer.borderColor = borderColor.cgColor
               
           }
           
       }

}


extension UIView{
    func roundedView(){
//        let maskPath1 = UIBezierPath(roundedRect: bounds,
//            byRoundingCorners: [.topLeft , .topRight],
//            cornerRadii: CGSize(width: 40, height: 40))
//        let maskLayer1 = CAShapeLayer()
//        maskLayer1.frame = bounds
//        maskLayer1.path = maskPath1.cgPath
//        layer.mask = maskLayer1
        //
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 20, height: 20))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func roundedViewForProfessional(){
//        let maskPath1 = UIBezierPath(roundedRect: bounds,
//            byRoundingCorners: [.topLeft , .topRight],
//            cornerRadii: CGSize(width: 40, height: 40))
//        let maskLayer1 = CAShapeLayer()
//        maskLayer1.frame = bounds
//        maskLayer1.path = maskPath1.cgPath
//        layer.mask = maskLayer1
        //
        
        DispatchQueue.main.async {
            
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [ .topRight,  .bottomRight],
                                    cornerRadii: CGSize(width: 6, height: 6))
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
        
    }
    
    func roundedViewFromTop(left:Int,right:Int ){
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: left, height: right))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func roundedViewFromBottom(left:Int,right:Int ){
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: left, height: right))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    
    func roundedViewBottom(){
//        let maskPath1 = UIBezierPath(roundedRect: bounds,
//            byRoundingCorners: [.topLeft , .topRight],
//            cornerRadii: CGSize(width: 40, height: 40))
//        let maskLayer1 = CAShapeLayer()
//        maskLayer1.frame = bounds
//        maskLayer1.path = maskPath1.cgPath
//        layer.mask = maskLayer1
        //
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 40, height: 40))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func roundedViewTab(){
//        let maskPath1 = UIBezierPath(roundedRect: bounds,
//            byRoundingCorners: [.topLeft , .topRight],
//            cornerRadii: CGSize(width: 40, height: 40))
//        let maskLayer1 = CAShapeLayer()
//        maskLayer1.frame = bounds
//        maskLayer1.path = maskPath1.cgPath
//        layer.mask = maskLayer1
        //
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 8, height: 8))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
        
        
    }
    
    func roundedViewForAddPost(){

        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 7, height: 7))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func roundedViewForCatHdr(){
//        let maskPath1 = UIBezierPath(roundedRect: bounds,
//            byRoundingCorners: [.topLeft , .topRight],
//            cornerRadii: CGSize(width: 40, height: 40))
//        let maskLayer1 = CAShapeLayer()
//        maskLayer1.frame = bounds
//        maskLayer1.path = maskPath1.cgPath
//        layer.mask = maskLayer1
        //
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 120, height: 120))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func roundedViewFromBottom(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 40, height: 40))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedViewFromRight(){
//        let maskPath1 = UIBezierPath(roundedRect: bounds,
//            byRoundingCorners: [.topLeft , .topRight],
//            cornerRadii: CGSize(width: 40, height: 40))
//        let maskLayer1 = CAShapeLayer()
//        maskLayer1.frame = bounds
//        maskLayer1.path = maskPath1.cgPath
//        layer.mask = maskLayer1
        //
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topRight],
                                    cornerRadii: CGSize(width: 40, height: 40))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func roundedSubProduct(){

        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topLeft, .bottomLeft],
                                    cornerRadii: CGSize(width: 12, height: 12))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
        
        
    }
    
    func roundedPostStack(){

        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 12, height: 12))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
        
        
    }
    
    func otherStoreRoundedView(){

        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 7, height: 7))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
}
