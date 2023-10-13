//
//  ViewController.swift
//  LaowaiQuestions
//
//  Created by Macbook on 3/29/21.
//

import UIKit
import NVActivityIndicatorView
import RxSwift
import RealmSwift
import KeychainSwift

class SplashScreenViewController: UIViewController {
    
    //    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    
    @IBOutlet weak var reloadBtn: RoundButton!
    @IBOutlet weak var indicator: UIView!

    // empty array
    var disposeBag = DisposeBag()
    var loginViewModel = LoginViewModel()
    
    var seconds = 3
    var myTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        startAnimation()
        
        navigationController?.navigationBar.barStyle = .black
        
        startCountdown()
        
        DispatchQueue.main.async {
       
            self.subscribeToResponse()
            
            self.initIndicator()
            self.startAnimation()
            self.startCountdown()
            
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        stopAnimation()
        
    }
    
    private func stopAnimation(){
        
        activityIndicatorView?.stopAnimating()
        indicator.isHidden = true
        
    }
    func startCountdown() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if UserData.getIsLogin(){
                                
                let status = Reach().connectionStatus()
                switch status {
                    
                case .unknown, .offline:
                    
                    self.view.makeToast("No Internet Connection!")
                    self.reloadBtn.isHidden = false
                    self.stopAnimation()
                    
                case .online(.wwan), .online(.wiFi):
                    self.reloadBtn.isHidden = true
                    self.LoginClicked()

                }
            }else{
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")//ChatSingleVC
                initialViewController.modalPresentationStyle = .fullScreen
                self.present(initialViewController, animated: true, completion: nil)
                
            }
        }
    }
    
    deinit {
        myTimer?.invalidate()
    }
    
    let keychain = KeychainSwift()
    
    public func LoginClicked() {
      
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        initialViewController.modalPresentationStyle = .fullScreen
        self.present(initialViewController, animated: true, completion: nil)
        
    }
    
    func sendApiTokenToServer()  {
        ServiceManger.instance.getDeviceToken(token: UserDefaults.standard.string(forKey: "pushyToken") ?? "") {
            (response) in
            
        }
    }
    
    public func checkLoginValid (){
        let pushyToken = UserDefaults.standard.string(forKey: "pushyToken") ?? ""
//        print("pushyToken \(pushyToken)")
        if (pushyToken != "") {
            self.loginViewModel.getCheckLoginValid()

        }else {
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            initialViewController.modalPresentationStyle = .fullScreen
            self.present(initialViewController, animated: true, completion: nil)
            
        }
    }
    
    public func subscribeToResponse (){
     
        self.loginViewModel.checkLoginValidObservable.subscribe { response in
            
            if (response.message == "Email Not Found"){
                UserData.setIsLogin(isLogin: false)
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                initialViewController.modalPresentationStyle = .fullScreen
                self.present(initialViewController, animated: true, completion: nil)
                
                return
            }
            
            if (response.data == "true") {
                self.sendApiTokenToServer()
                
//                let storyboard = UIStoryboard(name: "Home", bundle: nil)
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "NavControler")
//                initialViewController.modalPresentationStyle = .fullScreen
//                self.present(initialViewController, animated: true, completion: nil)
                
            }else {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                initialViewController.modalPresentationStyle = .fullScreen
                self.present(initialViewController, animated: true, completion: nil)
            }
            
        } onError: { _ in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)
        
    }
    
    
    @IBAction func reloadClicked(_ sender: Any) {
        startAnimation()
        startCountdown()
    }
    
    var activityIndicatorView : NVActivityIndicatorView?
    private func initIndicator (){
        
        let frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let indicatorType = NVActivityIndicatorType.ballPulse
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: indicatorType)
        
        //        activityIndicatorView?.startAnimating()
        activityIndicatorView?.color = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        self.indicator.addSubview(activityIndicatorView!)
    }
    private func startAnimation(){
        self.reloadBtn.isHidden = true

        indicator.isHidden = false
        activityIndicatorView?.startAnimating()
        
    }
}


