//
//  ChangeEmailWithoutAuthVc.swift
//  LaowaiQuestions
//
//  Created by Macbook on 24/01/2022.
//  Copyright © 2022 Maged Shaheen. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView

protocol ChangeEmailWithoutAuthProtocol {
    
    func setNewEmail(newEmail:String)
}
class ChangeEmailWithoutAuthVc: UIViewController {
    @IBOutlet weak var newEmailTf: CustomTextField!
    @IBOutlet weak var changeEmailBtn: RoundButton!

    @IBOutlet weak var indicator: UIView!

    var oldEmail:String?
    
    var seconds = 3
    var myTimer: Timer?
    var delege:ChangeEmailWithoutAuthProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initIndicator()
        
        newEmailTf.layer.borderColor =   #colorLiteral(red: 0.9294117647, green: 0.9450980392, blue: 0.968627451, alpha: 1)
        newEmailTf.layer.borderWidth = 1
        newEmailTf.layer.cornerRadius = 8

        newEmailTf.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
       

        newEmailTf.attributedPlaceholder = NSAttributedString(
            string: "New Email",
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7725490196, green: 0.8078431373, blue: 0.8784313725, alpha: 1)]
        )
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        
        dismiss(animated: true)
        
    }
    @IBAction func changeEmailClicked(_ sender: Any) {
        
        changeEmailBtn.isEnabled = false
        newEmailTf.resignFirstResponder()
        
        if self.newEmailTf.text?.isEmpty == true {
            view.makeToast("New Email Required!")
          }else {
            
              startAnimation()
              ServiceManger.instance.changeEmailWithoutAuth(newEmail: self.newEmailTf.text ?? "", oldEmail: self.oldEmail ?? ""){ (response) in
                  self.changeEmailBtn.isEnabled = true
                  
                  self.stopAnimation()
                  
                if (response != nil){

                    DispatchQueue.main.async { [weak self] in
                        
                        let msg = response?.message ?? ""
                        print("changeEmailWithoutAuth \( msg)")
                        self?.view.makeToast("\(msg)")

                        self?.myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
                            self?.seconds -= 1
                            if self?.seconds == 0 {
                                print("Go!")
                                
                                timer.invalidate()
                                let data = response?.message  ?? ""
                                print("data \(data)")
                                if (data == "Email Changed Successfully & Code Sent"){

                                    self?.delege?.setNewEmail(newEmail: self?.newEmailTf.text ?? "")
                                    
                                    self?.dismiss(animated: true)
                                    
                                }else {

                                }
                            }
                        })
                    }

                }else{

                    self.view.makeToast("Something went wrong!")
                    
                }
            }
          }
        
    }
    
    var activityIndicatorView : NVActivityIndicatorView?
    private func initIndicator (){
        
        let frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let indicatorType = NVActivityIndicatorType.ballPulse
         activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: indicatorType)
        
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
    
    deinit {
        // ViewController going away.  Kill the timer.
        myTimer?.invalidate()
    }

}
