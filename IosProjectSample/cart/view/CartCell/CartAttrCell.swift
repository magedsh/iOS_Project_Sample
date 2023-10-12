//
//  CartAttrCell.swift
//  LaowaiQuestions
//
//  Created by Macbook on 11/01/2023.
//  Copyright © 2023 Maged Shaheen. All rights reserved.
//

import UIKit
import RealmSwift

class CartAttrCell: UITableViewCell {
    private let realm = try! Realm()

    @IBOutlet weak var mainVIew: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var addView: UIView!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        counterView.layer.borderColor = #colorLiteral(red: 0.07450980392, green: 0.6235294118, blue: 0.8980392157, alpha: 0.9744141433)
        counterView.layer.borderWidth = 1
        counterView.layer.cornerRadius = 11.6
    }
    
    var cartProduct:CartAttributObject?
    var cartVC:CartVC?
    var mainCartRow:Int = -1
    var attrRow:Int = -1
  
    var ctns_all = 0.0
    var cmb_all = 0.0
    var weight_all = 0.0
    
    var currentQty = -1
    var maxQty = -1
    var minQty = -1

    func cellConfig(cartProduct:CartAttributObject? ,cartVC:CartVC? , mainCartRow:Int , attrRow:Int){
       
        self.cartVC = cartVC
        self.mainCartRow = mainCartRow
        self.attrRow = attrRow
        if ( self.cartProduct == nil){
            do{
                try? self.realm.write {
                    self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].qtyExpanded = false
                    self.cartVC?.getCartData()
                }
            }catch {
            }
        }
   
        self.cartProduct = cartProduct
        self.titleIv.text = cartProduct?.attr_name ?? ""
        self.codeTv.text = cartProduct?.attr_code ?? ""
        
//        ctns_all = Double( (cartProduct?.product_current_qty ?? 0 /  (cartProduct?.product_Inner_qty ?? 1)) )
//        cmb_all = (ctns_all * Double(cartProduct?.attr_cbm ?? 1) )
//        weight_all = (ctns_all * Double(cartProduct?.attr_weight ?? 1))
        
        let ctns_all = Double(round(1000 * (cartProduct?.attr_ctns_all ?? 0.0)) / 1000)
//        ctns_all = round(ctns_all)
        
        let weight_all = Double(round(1000 * (cartProduct?.attr_weight_all ?? 0.0)) / 1000)
//        weight_all = round(weight_all)
        
        let cmb_all = Double(round(1000 * (cartProduct?.attr_cbm_all ?? 0.0)) / 1000)
//        cmb_all = round(cmb_all)
        
        self.packingInformationLb.text = "\(ctns_all) CTNS  \(weight_all) KG  \(cmb_all) CBM"
        
        let allPrice = (cartProduct?.attr_price ?? 0) * (cartProduct?.product_current_qty ?? 1)
        let currency = self.cartVC?.currency ?? ""
        self.priceLb.text = "\(allPrice) \(currency)"
//        self.priceLb.text = "\(allPrice) \(cartVC?.currency ?? "")"


        let metaImageUrl = URL(string: "\(cartProduct?.attr_image ?? "")")
        
        productIv.kf.setImage(with: metaImageUrl)
        
       currentQty = cartProduct?.product_current_qty ?? 0
        maxQty = cartProduct?.attr_max_qty ?? 0
        minQty = cartProduct?.attr_min_qty ?? 0
        
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
    }

    @objc func toAddQty(){
        let vc =  UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "CartQtyChangeVC") as? CartQtyChangeVC

        vc?.currentQty = currentQty
        vc?.maxQty = maxQty
        vc?.minQty = minQty

        vc?.mainIndex = mainCartRow
        vc?.attrIndex = attrRow
        vc?.delegate = self
//        vc?.modalPresentationStyle = .fullScreen
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        self.cartVC?.present(vc!, animated: true, completion: nil)
    }
    
    
    @objc func addViewClick(){
        print("addViewClick")
        do{
            try! self.realm.write {
                
                var attr_max_qty = self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].attr_max_qty ?? 0
                var product_current_qty = self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].product_current_qty ?? 0
                
                if (product_current_qty <  attr_max_qty){
                    self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].product_current_qty += 1
                    product_current_qty += 1
                }
                
                currentQty = product_current_qty
//                let inner_qty = self.responseModel?.data?.packingQty ?? 1
//                var ctns_all = Double( qty ) / Double(inner_qty )
                
                self.qtyLb.text =     "\(cartProduct?.product_current_qty ?? 0)"
                var ctns_all = Double(cartProduct?.product_current_qty ?? 0) /  Double(cartProduct?.product_Inner_qty ?? 0)
                var cmb_all = (ctns_all * Double(cartProduct?.attr_cbm ?? 1) )
                var weight_all = (ctns_all * Double(cartProduct?.attr_weight ?? 1) )
                
                self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].attr_ctns_all = ctns_all
                self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].attr_cbm_all = cmb_all
                self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].attr_weight_all = weight_all
               
                ctns_all = Double(round(1000 * (ctns_all )) / 1000)
                weight_all = Double(round(1000 * (weight_all )) / 1000)
                cmb_all = Double(round(1000 * (cmb_all )) / 1000)
                
                self.packingInformationLb.text = "\(ctns_all) CTNS  \(weight_all) KG  \(cmb_all) CBM"
              
                let allPrice = (cartProduct?.attr_price ?? 0) * (cartProduct?.product_current_qty ?? 1)
                let currency = self.cartVC?.currency ?? ""
                self.priceLb.text = "\(allPrice) \(currency)"
//                self.priceLb.text = "\(allPrice)"
                
                self.cartVC?.getCartData()
            }
        }catch {
            print("addViewClickcatch")

        }
        
//        resetTimer()

    }
    
    @objc func subViewClick(){
        print("subViewClick")
        do{
            try! self.realm.write {

                var attr_min_qty = self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].attr_min_qty ?? 0
                var product_current_qty = self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].product_current_qty ?? 0
                
                if (product_current_qty > attr_min_qty){
                    self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].product_current_qty -= 1
                    product_current_qty -= 1
                }
                currentQty = product_current_qty

                self.qtyLb.text =     "\(cartProduct?.product_current_qty ?? 0)"
                var ctns_all = Double(cartProduct?.product_current_qty ?? 0) /  Double(cartProduct?.product_Inner_qty ?? 0)
                var cmb_all = (ctns_all * Double(cartProduct?.attr_cbm ?? 1) )
                var weight_all = (ctns_all * Double(cartProduct?.attr_weight ?? 1) )
                
                self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].attr_ctns_all = ctns_all
                self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].attr_cbm_all = cmb_all
                self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].attr_weight_all = weight_all
               
                ctns_all = Double(round(1000 * (ctns_all )) / 1000)
                weight_all = Double(round(1000 * (weight_all )) / 1000)
                cmb_all = Double(round(1000 * (cmb_all )) / 1000)
                
                self.packingInformationLb.text = "\(ctns_all) CTNS  \(weight_all) KG  \(cmb_all) CBM"
              
                let allPrice = (cartProduct?.attr_price ?? 0) * (cartProduct?.product_current_qty ?? 1)
                let currency = self.cartVC?.currency ?? ""
                self.priceLb.text = "\(allPrice) \(currency)"
//                self.priceLb.text = "\(allPrice)"
                
                self.cartVC?.getCartData()
            }
        }catch {
            print("subViewClickcatch")
        }
//        resetTimer()

    }
    
    @objc func qtyViewClicked(){
        if (cartProduct?.qtyExpanded == false ) {
            
            do{
                try! self.realm.write {
                    
                    if cartVC != nil && self.cartVC?.cartResult != nil{
                       
                        for (mainIndex, product) in self.cartVC!.cartResult!.enumerated() {
                            if product.cartAttributs.isEmpty {
                                self.cartVC?.cartResult?[mainIndex].qtyExpanded = false
                            }else {
                                for (attrRow, _) in self.cartVC!.cartResult![mainIndex].cartAttributs.enumerated() {
                                    self.cartVC?.cartResult?[mainIndex].cartAttributs[ attrRow].qtyExpanded = false
                                }
                            }
                            
                        }
                     
                        
                        self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].qtyExpanded = true
                        self.cartVC?.getCartData()
                    }
   
                }
            }catch {
                
            }
            
            UIView.animate(withDuration: 0.3) {
                self.qtyLb.text =     "\(self.cartProduct?.product_current_qty ?? 0)"
                self.qtyViewWidth.constant = 77.7
                self.increaseQtyWidth.constant = 17.8
                self.decreaseQtyWidth.constant = 17.8
                self.cartVC?.view.layoutIfNeeded()
            }
            qtyLb.isUserInteractionEnabled = true

        }else {
            
        }
//        resetTimer()

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
                    
                    self.cartVC?.cartResult?[self.mainCartRow].cartAttributs[ self.attrRow].qtyExpanded = false
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
    
}

extension CartAttrCell : AddQtyDelegate {
    func passQty(qty: Int, mainIndex: Int, attrIndex: Int) {
        print("qtyqtyqtyAttr \(qty)")
        print("qtyqtyqtyAttr \(mainIndex)")
        print("attrIndex \(attrIndex)")

            do {
                try! self.realm.write {
                    
//                    if (attrIndex == -1) {
//                        self.cartVC?.cartResult?[mainIndex].product_current_qty =  qty
//                    }else {
                        self.cartVC?.cartResult?[mainIndex].cartAttributs[attrIndex].product_current_qty =  qty
//                    }
                    self.cartVC?.getCartData()

                }
            }catch var e{
                print("exeption \(e)")
            }
        
        DispatchQueue.main.async {
         
            self.addViewClick()
            self.subViewClick()
        }
        
    }

}
