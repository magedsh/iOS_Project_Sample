//
//  CartWithAttrCell.swift
//  LaowaiQuestions
//
//  Created by Macbook on 11/01/2023.
//  Copyright © 2023 Maged Shaheen. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
class CartWithAttrCell: UITableViewCell {

    @IBOutlet weak var titleIv: UILabel!

    @IBOutlet weak var tableviewHight: NSLayoutConstraint!
    
    @IBOutlet weak var tableview: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    var cartProduct:CartDataObject?
    var mainIndex = -1

    var storeId = 0
    private let realm = try! Realm()
    var cartVC:CartVC?
    func cellConfig(cartProduct:CartDataObject , mainIndex : Int ,storeId:Int , cartVC:CartVC ){
        
        self.cartVC = cartVC
        self.storeId = storeId
        let attrCount = cartProduct.cartAttributs.count
        self.mainIndex = mainIndex
        self.cartProduct = cartProduct
      
        self.titleIv.text = cartProduct.product_name
        //MARK: - setup tableview
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.backgroundColor = .white
        let tableHight = 80 * attrCount
        self.tableviewHight.constant = CGFloat(tableHight)
        tableview?.register(UINib(nibName: "CartAttrCell", bundle: nil), forCellReuseIdentifier: "CartAttrCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CartWithAttrCell:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cartProduct?.cartAttributs.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let attribute =  self.cartProduct?.cartAttributs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartAttrCell") as! CartAttrCell
        cell.cellConfig(cartProduct: attribute, cartVC: cartVC , mainCartRow: mainIndex , attrRow:indexPath.row)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(style: .normal, title: "Remove") { (action, sourceView, success:(Bool) -> Void) in

            do {
                try! self.realm.write {
                    
                    self.cartVC?.cartResult?[self.mainIndex].cartAttributs.remove(at: indexPath.row)
                    
                    self.cartVC?.getCartData()

                }
            }catch var e{
                print("exeption \(e)")
            }
            
            
            do {
                
                try! self.realm.write{
                    if self.cartVC?.cartResult?[self.mainIndex].cartAttributs.count == 0 {
                        self.realm.delete((self.cartVC?.cartResult?[self.mainIndex])!)
                        self.cartVC?.getCartData()
                    }
                }
                
            }catch var e{
                print("delete \(e)")
            }

            success(true)
            
        }
        
        removeAction.backgroundColor = UIColor.red //#colorLiteral(red: 0.07450980392, green: 0.6235294118, blue: 0.8980392157, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [removeAction])
        
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartAttrCell") as! CartAttrCell

        
    }
}
