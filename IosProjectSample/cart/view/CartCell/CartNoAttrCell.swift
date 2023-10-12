//
//  CartNoAttrCell.swift
//  LaowaiQuestions
//
//  Created by Macbook on 11/01/2023.
//  Copyright © 2023 Maged Shaheen. All rights reserved.
//

import UIKit
import RealmSwift

class CartNoAttrCell: UITableViewCell {
    private static var a = 0
    fileprivate static var b = 0

    private let realm = try! Realm()

    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var productIv: UIImageView!
    @IBOutlet weak var titleIv: UILabel!
    @IBOutlet weak var codeTv: UILabel!
    @IBOutlet weak var packingInformationLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var qtyLb: UILabel!
    @IBOutlet weak var decreaseQtyWidth: NSLayoutConstraint!// 17.8 ,0
    @IBOutlet weak var increaseQtyWidth: NSLayoutConstraint! // 17.8 ,0
    @IBOutlet weak var qtyViewWidth: NSLayoutConstraint! // 77.7 ,36.36
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var addView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        counterView.layer.borderColor = #colorLiteral(red: 0.07450980392, green: 0.6235294118, blue: 0.8980392157, alpha: 0.9744141433)
        counterView.layer.borderWidth = 1
        counterView.layer.cornerRadius = 11.6
        
    }
   
    var ctns_all = 0.0
    var cmb_all = 0.0
    var weight_all = 0.0
    var cartVC:CartVC?
    var mainCartRow = -1
    
    var cartProduct:CartDataObject?

    @IBOutlet weak var mainVIew: UIView!
    
    var currentQty = -1
    var maxQty = -1
    var minQty = -1
    
    func cellConfig(cartProduct:CartDataObject?,cartVC:CartVC? , index :Int){
     
        self.cartVC = cartVC
        mainCartRow = index
        var ctns_all = 0.0

        if ( self.cartProduct == nil){
            do{
                try? self.realm.write {
                    let product_Inner_qty = cartProduct?.product_Inner_qty ?? 0
                   
//                    var ctns_all = 0.0
                    if (product_Inner_qty == 0) {
                        ctns_all = 0.0
                    }else {
                        ctns_all = Double( (cartProduct?.product_current_qty ?? 1 /  (cartProduct?.product_Inner_qty ?? 1)) )
                    }
                    
                    let cmb_all = (ctns_all * Double(cartProduct?.product_cbm ?? 0) )
                    let weight_all = (ctns_all * Double(cartProduct?.product_weight ?? 0) )
                    
                    self.cartVC?.cartResult?[self.mainCartRow].product_ctns = ctns_all
                    self.cartVC?.cartResult?[self.mainCartRow].product_cbm = cmb_all
                    self.cartVC?.cartResult?[self.mainCartRow].product_weight = weight_all
                    self.cartVC?.cartResult?[self.mainCartRow].qtyExpanded = false
                    
                    self.cartVC?.getCartData()

                }
            }catch {
                
            }
            
        }
        
        self.cartProduct = cartProduct

        self.titleIv.text = cartProduct?.product_name ?? ""
        self.codeTv.text = cartProduct?.product_code ?? ""
      
        let allPrice = (cartProduct?.product_price ?? 0) * (cartProduct?.product_current_qty ?? 1)
        self.priceLb.text = "\(allPrice) \(cartVC?.currency ?? "")"
        self.qtyLb.text =     "\(cartProduct?.product_current_qty ?? 0)"

        let url = URL(string: cartProduct?.product_image ?? "")
        self.productIv.kf.setImage(with: url)
        
//        ctns_all = Double( (cartProduct?.product_current_qty ?? 0 /  (cartProduct?.product_Inner_qty ?? 1)) )
        cmb_all = (ctns_all * Double(cartProduct?.product_cbm ?? 1) )
        weight_all = (ctns_all * Double(cartProduct?.product_weight ?? 1))
        
        
        self.packingInformationLb.text = "\(ctns_all) CTNS  \(weight_all) KG  \(cmb_all) CBM"
        


        //MARK: -
        if cartProduct?.qtyExpanded ?? false  {
            qtyViewWidth.constant = 77.7
            increaseQtyWidth.constant = 17.8
            decreaseQtyWidth.constant = 17.8
            
            self.qtyLb.text =     "\(cartProduct?.product_current_qty ?? 0)"
        }else {
            qtyViewWidth.constant = 36.36
            increaseQtyWidth.constant = 0
            decreaseQtyWidth.constant = 0
            
            self.qtyLb.text =     "x\(cartProduct?.product_current_qty ?? 0)"
        }
      
        currentQty = cartProduct?.product_current_qty ?? 0
         maxQty = cartProduct?.product_max_qty ?? 0
         minQty = cartProduct?.product_min_qty ?? 0
        
        //MARK: -
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.qtyViewClicked))
        self.counterView.isUserInteractionEnabled = true
        self.counterView.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.addViewClick))
        self.addView.isUserInteractionEnabled = true
        self.addView.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(self.subViewClick))
        self.subView.isUserInteractionEnabled = true
        self.subView.addGestureRecognizer(tapGesture3)
        
        //mainVIew
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(self.collapseQtyView))
        self.mainVIew.isUserInteractionEnabled = true
        self.mainVIew.addGestureRecognizer(tapGesture4)
        let tabGest5 = UITapGestureRecognizer(target: self, action: #selector(toAddQty))
        qtyLb.isUserInteractionEnabled = false
        qtyLb.addGestureRecognizer(tabGest5)
        
        if ( self.cartVC?.cartResult?[self.mainCartRow].qtyExpanded == true) {
            qtyLb.isUserInteractionEnabled = true
        }
    }

    @objc func toAddQty(){
        let vc =  UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "CartQtyChangeVC") as? CartQtyChangeVC

        vc?.currentQty = currentQty
        vc?.maxQty = maxQty
        vc?.minQty = minQty

        vc?.mainIndex = mainCartRow
        vc?.attrIndex = -1
        vc?.delegate = cartVC.self
//        vc?.modalPresentationStyle = .fullScreen
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        self.cartVC?.present(vc!, animated: false, completion: nil)
    }
    @objc func collapseQtyView(){
        print("collapseQtyView")
        UIView.animate(withDuration: 0.3) {
            self.qtyLb.text =     "x\(self.cartProduct?.product_current_qty ?? 0)"
            self.qtyViewWidth.constant = 36.36
            self.increaseQtyWidth.constant = 0
            self.decreaseQtyWidth.constant = 0
            self.cartVC?.view.layoutIfNeeded()
            
            do{
                try! self.realm.write {
                    
                    self.cartVC?.cartResult?[self.mainCartRow].qtyExpanded = false
                    self.cartVC?.getCartData()
   
                }
            }catch {
                
            }
        }
        
        qtyLb.isUserInteractionEnabled = false

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func addViewClick(){
        print("addViewClick")
        
        do{
            try! self.realm.write {
                
                let attr_max_qty = self.cartVC?.cartResult?[self.mainCartRow].product_max_qty ?? 0
                let product_current_qty = self.cartVC?.cartResult?[self.mainCartRow].product_current_qty ?? 0
                
                if (product_current_qty <  attr_max_qty){
                    self.cartVC?.cartResult?[self.mainCartRow].product_current_qty += 1

                }
                
                self.qtyLb.text =     "\(cartProduct?.product_current_qty ?? 0)"
                let product_Inner_qty = cartProduct?.product_Inner_qty ?? 0

                if (product_Inner_qty == 0) {
                    ctns_all = 0.0
                }else {
                    ctns_all = Double( (cartProduct?.product_current_qty ?? 1 /  (cartProduct?.product_Inner_qty ?? 1)) )
                }
                
//                let ctns_all = Double( (cartProduct?.product_current_qty ?? 0 /  (cartProduct?.product_Inner_qty ?? 0)) )
                let cmb_all = (ctns_all * Double(cartProduct?.product_cbm ?? 1) )
                let weight_all = (ctns_all * Double(cartProduct?.product_weight ?? 1) )
                
                self.cartVC?.cartResult?[self.mainCartRow].product_ctns_all = ctns_all
                self.cartVC?.cartResult?[self.mainCartRow].product_cbm_all = cmb_all
                self.cartVC?.cartResult?[self.mainCartRow].product_weight_all = weight_all
                
                self.packingInformationLb.text = "\(ctns_all) CTNS  \(weight_all) KG  \(cmb_all) CBM"
              
                let allPrice = (cartProduct?.product_price ?? 0) * (cartProduct?.product_current_qty ?? 1)
                let currency = self.cartVC?.currency ?? ""
                self.priceLb.text = "\(allPrice) \(currency)"
                
                self.cartVC?.getCartData()

            }
        }catch {
            print("addViewClickcatch")

        }
    }
    @objc func subViewClick(){
        print("subViewClick")

        do{
            try! self.realm.write {
              
                let attr_min_qty = self.cartVC?.cartResult?[self.mainCartRow].product_min_qty ?? 0
                let product_current_qty = self.cartVC?.cartResult?[self.mainCartRow].product_current_qty ?? 0
                
                if (product_current_qty > attr_min_qty){
                    self.cartVC?.cartResult?[self.mainCartRow].product_current_qty -= 1
                }
                self.qtyLb.text =     "\(cartProduct?.product_current_qty ?? 0)"
              
                let product_Inner_qty = cartProduct?.product_Inner_qty ?? 0

                if (product_Inner_qty == 0) {
                    ctns_all = 0.0
                }else {
                    ctns_all = Double( (cartProduct?.product_current_qty ?? 1 /  (cartProduct?.product_Inner_qty ?? 1)) )
                }
                
//                let ctns_all = Double( (cartProduct?.product_current_qty ?? 0 /  (cartProduct?.product_Inner_qty ?? 0)) )
                let cmb_all = (ctns_all * Double(cartProduct?.product_cbm ?? 1) )
                let weight_all = (ctns_all * Double(cartProduct?.product_weight ?? 1) )
                
                self.cartVC?.cartResult?[self.mainCartRow].product_ctns_all = ctns_all
                self.cartVC?.cartResult?[self.mainCartRow].product_cbm_all = cmb_all
                self.cartVC?.cartResult?[self.mainCartRow].product_weight_all = weight_all
                
                self.packingInformationLb.text = "\(ctns_all) CTNS  \(weight_all) KG  \(cmb_all) CBM"
                self.cartVC?.getCartData()
             
                let allPrice = (cartProduct?.product_price ?? 0) * (cartProduct?.product_current_qty ?? 1)
                
                let currency = self.cartVC?.currency ?? ""
                self.priceLb.text = "\(allPrice) \(currency)"
//                self.priceLb.text = "\(allPrice) \(self.cartVC?.currency ?? "")"
            }
        }catch {
            print("subViewClickcatch")

        }
    }
    @objc func qtyViewClicked(){
        
        if (cartProduct?.qtyExpanded == false ) {
            
            do{
                try! self.realm.write {
                    

   
                    if cartVC != nil && self.cartVC?.cartResult != nil{
                       
                        for (mainIndex, _) in self.cartVC!.cartResult!.enumerated() {
                            self.cartVC?.cartResult?[mainIndex].qtyExpanded = false
                        }
                        
                        self.cartVC?.cartResult?[self.mainCartRow].qtyExpanded = true
                        self.cartVC?.getCartData()
                    }
                    
                }
                
            }catch {}
            
            UIView.animate(withDuration: 0.3) {
                self.qtyLb.text =     "\(self.cartProduct?.product_current_qty ?? 0)"
                self.qtyViewWidth.constant = 77.7
                self.increaseQtyWidth.constant = 17.8
                self.decreaseQtyWidth.constant = 17.8
                self.cartVC?.view.layoutIfNeeded()
            }
            qtyLb.isUserInteractionEnabled = true

        }

    }
}
