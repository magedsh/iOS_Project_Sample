//
//  StoreCartVC.swift
//  LaowaiQuestions
//
//  Created by Macbook on 11/01/2023.
//  Copyright © 2023 Maged Shaheen. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RealmSwift
import NVActivityIndicatorView
import FittedSheets

protocol CartDisappeareDeleget {
    func vcDidDisappear()
}

protocol CartOrderDone{
    func orderCreated()
}

class CartVC: UIViewController {
  
    private let realm = try! Realm()

    @IBOutlet weak var tableview: UITableView!
    
    let disposeBag = DisposeBag()
    let viewmodel = CartViewModel()

    var storeId = 0
    var userId = 0

    var cartResult  : Results<CartDataObject>?

    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var ctnsLb: UILabel!
    @IBOutlet weak var weightLb: UILabel!
    @IBOutlet weak var cbmLb: UILabel!
    
    @IBOutlet weak var continueShipingView: UIView!
    @IBOutlet weak var sendToSellerView: UIView!
    
    @IBOutlet weak var indicator: UIView!
    var currentVC:UIViewController?
    var continueShopingDelegate:continueShopingDelegate?
    var cartDisappeareDeleget:CartDisappeareDeleget?
    var cartOrderDone:CartOrderDone?
    
    var currency = ""
    var myStore = false

    @IBOutlet weak var sendToSellerLb: UILabel!
    @IBOutlet weak var optionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUi()
        setupTableView()
        
        subscribeToFetchCartResult()
        subscribeToCart()
        
        subscribeToSendToSellerLoading()
        subscribeToSendToSeller()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.getCartData()
        }

        self.tableview.delegate = self

    }

    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
    }
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfPost>(configureCell: configureCell)
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionOfPost>.ConfigureCell = { [unowned self] (dataSource, tableView, indexPath, item) in
        
        switch item {
            
        case let item where item.cartAttributs.isEmpty :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartNoAttrCell") as! CartNoAttrCell
            cell.cellConfig(cartProduct: item, cartVC: self, index: indexPath.row)
            return cell

        case let item where item.cartAttributs.isEmpty == false:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartWithAttrCell") as! CartWithAttrCell
            cell.cellConfig(cartProduct: item, mainIndex: indexPath.row, storeId: storeId, cartVC: self)
            return cell

        default:
            return UITableViewCell()
        }
        
    }
    
    func setupUi(){
        
        initIndicator()
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.sendToSeller))
        self.sendToSellerView.isUserInteractionEnabled = true
        self.sendToSellerView.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.continueShoping))
        self.continueShipingView.isUserInteractionEnabled = true
        self.continueShipingView.addGestureRecognizer(tapGesture2)
        self.optionView.isHidden = true
        
    }
    
    @objc func sendToSeller(){
        viewmodel.makeOrder(type: "order",user_id: 0,total_price: self.price, total_ctns: self.ctns_all, total_cbm: self.cmb_all, total_weight: self.weight_all, store_id: storeId, products: cartResult )
        
    }
  
    func subscribeToSendToSeller(){
        
        viewmodel.sendToSellerObservable.subscribe{ successResponseModel in
            
            print("successResponseModelsuccessResponseModel \(successResponseModel)")
            if (successResponseModel.success ?? false ){
                do {
                    try self.realm.write {
                      
                        self.realm.delete(self.cartResult!)
                        self.getCartData()
                        self.view.makeToast(successResponseModel.message ?? "")
                        self.cartOrderDone?.orderCreated()
                        self.dismiss(animated: true)

                    }
                }catch{}
                
            }else {
                self.view.makeToast(successResponseModel.message ?? "Something went wronge")
            }
            
        }.disposed(by: disposeBag)
    }
    
    func subscribeToSendToSellerLoading() {
        
        viewmodel.sendToSellerLoadingBehavior.subscribe { [weak self] isLoading in
            
            guard let self = self else {return}
            if (isLoading){
                self.startAnimation()
            }else {
                self.stopAnimation()
            }
            
        }.disposed(by: disposeBag)
    }
    
    @objc func continueShoping(){
        
        if (currentVC is MyStoreVC) {
            
            dismiss(animated: true)
            
        }else if (currentVC is SingleProductVC){
            continueShopingDelegate?.continueConfirmed()
//            self.currentVC?.navigationController?.popViewController(animated: false)
            dismiss(animated: true)
            
        }else if (currentVC is SingleProductAttrVC) {
            
            let vc = currentVC as! SingleProductAttrVC
            vc.continueClicked()
            dismiss(animated: true)
            
        }
        
    }
    
    func setupTableView(){
        
        tableview?.register(UINib(nibName: "CartNoAttrCell", bundle: nil), forCellReuseIdentifier: "CartNoAttrCell")
        tableview?.register(UINib(nibName: "CartWithAttrCell", bundle: nil), forCellReuseIdentifier: "CartWithAttrCell")

        tableview.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableview.separatorStyle = .none
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath  in
            if self.cartResult?[indexPath.row].cartAttributs.count == 0 {
            
                return true
                
            }else {
                return false
            }
        }
        
        tableview.rx
          .itemDeleted
          .subscribe(onNext: { indexPath in
              do {
                  try! self.realm.write{
                      if self.cartResult?[indexPath.row].cartAttributs.count == 0 {
                          self.realm.delete((self.cartResult?[indexPath.row])!)
                          self.getCartData()
                      }
                  }
              }catch var e{
                  print("delete \(e)")
              }

          })
          .disposed(by: disposeBag)

        tableview.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    func getCartData(){
        viewmodel.getCartFromDB(storeId: storeId)
        viewmodel.getCartResultFromDB(storeId:  storeId)

    }

    var cartItems: [CartDataObject] = [CartDataObject]()
    func subscribeToCart(){
        
        viewmodel.cartSectionObservable
            .bind(to: self.tableview.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        //       ======
        viewmodel.cartSectionObservable.subscribe{ cartProductList in

            let elements = cartProductList.element?[0].items

            guard let items = elements else {return}
            
            self.cartItems = items
            
            var price = 0.0
            var ctns_all:Double = 0.0
            var weight_all = 0.0
            var cmb_all = 0.0

            items.forEach({ product in
                
                self.userId = product.store_owner_id
                
                if product.cartAttributs.isEmpty {
                    price += Double(product.product_price * product.product_current_qty )
                }else {

                    product.cartAttributs.forEach { attr in

                        let product_current_qty = attr.product_current_qty
                        print("product_current_qty \(attr.product_current_qty)")
                        price += Double(attr.attr_price * attr.product_current_qty )

                        ctns_all += attr.attr_ctns_all
                        cmb_all += attr.attr_cbm_all
                        weight_all += attr.attr_weight_all

                    }
                }
            })
        }.disposed(by: disposeBag)
        
    }
    var ctns_all:Double = 0.0
    
    var weight_all = 0.0
    var price = 0.0

    func subscribeToFetchCartResult(){
        viewmodel.cartResultObservable.subscribe { cartProductList in
            self.ctns_all = 0.0
            
            self.weight_all = 0.0
            self.price = 0.0
            
            self.cartResult = cartProductList.element

            let items = cartProductList.element
            
            for (_ , product) in items!.enumerated() {
                if product.cartAttributs.isEmpty {
                    self.price += Double(product.product_price * product.product_current_qty )
                    
                    if (product.product_Inner_qty  != 0){
                        self.ctns_all += Double( product.product_current_qty  /  product.product_Inner_qty  )
                    }
                    self.weight_all += ( self.ctns_all * Double(product.product_weight ) )
                    
                }else {
              
                    product.cartAttributs.forEach { attr in
                        

                        self.price += Double(attr.attr_price * attr.product_current_qty )
                        
                        self.ctns_all += attr.attr_ctns_all
                        self.weight_all += attr.attr_weight_all

                    }
                }
            }
            
            self.priceLb.text = "\( self.price) \(self.currency)"
            
            self.ctns_all = Double(round(1000 * ( self.ctns_all )) / 1000)
            self.weight_all = Double(round(1000 * ( self.weight_all )) / 1000)

            self.ctnsLb.text = "\( self.ctns_all) CTNS"
            self.weightLb.text = "\( self.weight_all) KG"
            self.optionView.isHidden = false

            
        }.disposed(by: disposeBag)
        
    }
    
    var activityIndicatorView : NVActivityIndicatorView?
    private func initIndicator (){
        
        let frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let indicatorType = NVActivityIndicatorType.ballPulse
         activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: indicatorType)
        
        activityIndicatorView?.color =  #colorLiteral(red: 0.07450980392, green: 0.6235294118, blue: 0.8980392157, alpha: 1)
        
//        activityIndicatorView?.startAnimating()
        
        self.indicator.addSubview(activityIndicatorView!)
    }
    
    private func startAnimation(){
        indicator.isHidden = false
        activityIndicatorView?.startAnimating()
    }
    
    private func stopAnimation(){
        
        activityIndicatorView?.stopAnimating()
        indicator.isHidden = true
        
    }
    func toChatSingle()  {

    }
        
    deinit {
        print("deinit")
    }
}
