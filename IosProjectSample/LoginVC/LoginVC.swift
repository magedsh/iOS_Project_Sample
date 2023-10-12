//
//  LoginVC.swift
//  LaowaiQuestions
//
//  Created by Macbook on 4/7/21.
//

import UIKit
import KeychainSwift
//import JGProgressHUD
import AuthenticationServices

import Toast_Swift
import NVActivityIndicatorView
import RxSwift

enum LoginType:String {
    case normal = "normal"
    case apple = "apple"
    case wechat = "wechat"
}

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5);
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5);
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
}

class LoginVC: UIViewController , WXApiDelegate  {
    //    var hud : JGProgressHUD?
    @IBOutlet weak var indicator: UIView!
    var thirdPartyLogin = "THIRD_PARTY_PASS"
    
    var error : String?
    
    @IBOutlet weak var emailTf: UITextField!
    //    var isPasswordHiden = true
    
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loginBtn: RoundButton!
    
    @IBOutlet weak var signUpLn: UILabel!
    
    @IBOutlet var mainView: UIView!
    
    let keychain = KeychainSwift()
    
    @IBOutlet weak var appleView: UIStackView!
    
    let  signInButton = ASAuthorizationAppleIDButton()
    
    let loginViewModel = LoginViewModel()
    let dispose = DisposeBag()
    
    var appleUserIdentifier =  ""
    var appleEmail = ""
    var appleFullName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        appleLoginSubscribe()
        loadingAppleLoginSubscribe()
        setupGestures()
        
    }
    
    func setupUI(){
        initIndicator()
        
        passwordTf.isSecureTextEntry = true
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        let myColor = UIColor.lightGray
        
        emailTf.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.9450980392, blue: 0.968627451, alpha: 1)
        emailTf.layer.borderWidth = 1
        emailTf.layer.cornerRadius = 8
        
        passwordTf.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.9450980392, blue: 0.968627451, alpha: 1)
        passwordTf.layer.borderWidth = 1
        passwordTf.layer.cornerRadius = 8
        
        passwordTf.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        emailTf.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        emailTf.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7725490196, green: 0.8078431373, blue: 0.8784313725, alpha: 1)]
        )
        
        passwordTf.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7725490196, green: 0.8078431373, blue: 0.8784313725, alpha: 1)]
        )
        
        if UserData.getIsLogin(){
            
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "NavControler")
            
            present(initialViewController, animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    func setupGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUp))
        
        signUpLn?.isUserInteractionEnabled = true
        signUpLn?.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(closekeyboard))
        
        mainView?.isUserInteractionEnabled = true
        mainView?.addGestureRecognizer(tapGesture1)
        
        appleView.addArrangedSubview(signInButton)
        //        appleView.addTarget(self, action: #selector(appleLogintapped), for: .touchUpInside)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(appleLogintapped))
        
        signInButton.isUserInteractionEnabled = true
        signInButton.addGestureRecognizer(tapGesture2)
    }
    
    func appleLoginSubscribe(){
        self.loginViewModel.appleLoginValidObservable.subscribe{ response in
            
            if (response.data != nil) {
               
                if (self.appleLoginClear) {
                    
                    self.saveLoginData(response: response, password: self.thirdPartyLogin, loginFromThirdParty: response.data?.userData?.account_type ?? "")
                    
//                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
//                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "NavControler")
//
//                    initialViewController.modalPresentationStyle = .fullScreen
//
//                    self.present(initialViewController, animated: true, completion: nil)
                }else {
                    self.checkUserForApple(app_id: self.appleUserIdentifier, name: self.appleFullName, email: self.appleEmail)
                }
                
            }else {
                self.view.makeToast(response.message ?? "Something went wrong!")
            }
            
        }.disposed(by: dispose)
    }
    
    func loadingAppleLoginSubscribe(){
        self.loginViewModel.loadingBehavior.subscribe{isLoading  in
            print("loadingApple \(isLoading)")
            if isLoading {
                self.startAnimation()
            }else {
                self.stopAnimation()
            }
            
        }.disposed(by: self.dispose)
    }
    func saveLoginData(response: LoginModel? , password:String , loginFromThirdParty:String){
        
        if (response != nil){
            
            DispatchQueue.main.async { [weak self] in
                
                let pushyToken = UserDefaults.standard.string(forKey: "pushyToken") ?? ""
                ServiceManger.instance.getDeviceToken(token: pushyToken) {
                    (response) in
                }
                
                self?.stopAnimation()
                UserData.setIsLogin(isLogin: true)
                self?.keychain.set(password, forKey: UserData.USER_PASSWORD)
                UserData.setLoginFromThirdParty(thirdParty: loginFromThirdParty)
                
                let  usefulsNo = response?.data?.userData?.usefuls ?? 0
                UserData.setUserOfficial(uofficial: usefulsNo)
                UserData.setuser_bio(bio: response?.data?.userData?.bio ?? "")
                
                if response?.data?.userData?.private ==  0{
                    UserData.setIsPrivate(isPrivate: false)
                }else if response?.data?.userData?.private == 1{
                    UserData.setIsPrivate(isPrivate: true)
                }
                
                UserData.setUserAvatar(avatar: response?.data?.userData?.image_url ?? "")
                UserData.setUserId(userId: response?.data?.userData?.id ?? 0)
                UserData.setUserName(userName: response?.data?.userData?.name ?? "")
                UserData.setFriendsCount(friendsCount: response?.data?.userData?.friends_count ?? 0)
                
                let uuid =  response?.data?.userData?.uuid ?? ""
                UserData.setUUID(userId: uuid)
                let uselful =  response?.data?.userData?.replys_useful_count ?? 0
                
                UserData.setUseful(uselful: uselful)
                UserData.setUSER_EMAIL(email: response?.data?.userData?.email ?? "")
                UserData.setUserphone(phone: response?.data?.userData?.phone ?? "")
                UserData.setapi_token(access_token: response?.data?.token ?? "")
                UserData.setCountryCode(country_code:  response?.data?.userData?.country_code ?? "")

                // store
                UserData.isUserHasStore(user_hass_store: response?.data?.userData?.store ?? false)
                
                var storeId = response?.data?.userData?.store_id ?? 0
                UserData.setUserStoreId(user_storeId: storeId)
                
                if (storeId != 0 ){
                    UserData.isUserHasStore(user_hass_store: true)
                }else {
                    UserData.isUserHasStore(user_hass_store: false)
                }
                // store activation state
                if ((response?.data?.userData?.store == nil || !(response?.data?.userData?.store ?? false)) && storeId != 0 ){
                    UserData.isStoreActive(isActive: false)
                }else if (response?.data?.userData?.store ?? false ){
                    UserData.isStoreActive(isActive: true)
                }else if (!(response?.data?.userData?.store ?? false )){
                    UserData.isStoreActive(isActive: false)
                }
            }
        }
    }
    
    @objc func appleLogintapped(){
        print("appleLogintapped")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    var activityIndicatorView : NVActivityIndicatorView?
    private func initIndicator (){
        
        let frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let indicatorType = NVActivityIndicatorType.ballPulse
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: indicatorType)
        
        activityIndicatorView?.color =  #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
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
    
    @IBAction func forgetPasswordClicked(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
//
//        initialViewController.modalPresentationStyle = .fullScreen
//        present(initialViewController, animated: true, completion: nil)
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    var loginType = LoginType.normal
    @IBAction func LoginClicked(_ sender: Any) {
        loginType = .apple
        dismissKeyboard()
        checkUser()
    }
    
    func checkUser()  {
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown,.offline:
            self.view.makeToast("No Internet Connection!")
        case .online(.wwan), .online(.wiFi):

            if self.emailTf.text?.isEmpty == true {
                self.view.makeToast("Email Required!")
            }
            
            else if self.passwordTf.text?.isEmpty == true {
                self.view.makeToast("Password Required!")
            }else{
                startAnimation()
                DispatchQueue.main.async { [weak self] in
                    ServiceManger.instance.checkUser(email: self?.emailTf.text ?? "", password: self?.passwordTf.text  ?? "") { checkUserResponse in
                        self?.stopAnimation()
                        if checkUserResponse != nil{
                            
                            let isEmailVerified = checkUserResponse?.emailVerified
                            let isPhoneVerified = checkUserResponse?.phoneVerified
                            let isNewUSER = checkUserResponse?.newUser
                            
                            let email = self?.emailTf.text ?? ""
                            let password = self?.passwordTf.text ?? ""
                            
                            if ((isEmailVerified == true ) && (isPhoneVerified == true)) {
                                self?.login();
                            } else if (isEmailVerified == false) {
                                // Do something
                            }else if (isPhoneVerified == false){
                                // Do something
                            }
                        }else {
                            self?.view.makeToast("This email does not exist!")
                        }
                    }
                }
            }
        }
    }
    
    @objc func closekeyboard (){
        
        view.endEditing(true)
        
    }
    func login()  {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.view.makeToast("No Internet Connection!")
        case .online(.wwan), .online(.wiFi):
            if self.emailTf.text?.isEmpty == true {
                self.view.makeToast("Email Required")
            }
            else if self.passwordTf.text?.isEmpty == true {
                self.view.makeToast("Password Required")
            }else{
                
                startAnimation()
                let password = passwordTf.text ?? ""
                ServiceManger.instance.logIn(email: emailTf.text!, password: password) { (response,error) in
                    if (response != nil){
                        DispatchQueue.main.async { [weak self] in
                            
                            self?.stopAnimation()
                            UserData.setIsLogin(isLogin: true)
                            UserData.setLoginFromThirdParty(thirdParty: "email")
                            //                            let password = self?.passwordTf.text
                            self?.keychain.set(password, forKey: UserData.USER_PASSWORD)
                            UserData.setUSerPassword(password:  password)
                            
                            let  usefulsNo = response?.data?.userData?.usefuls ?? 0
                            UserData.setUserOfficial(uofficial: usefulsNo)
                            UserData.setuser_bio(bio: response?.data?.userData?.bio ?? "")
                            
                            if response?.data?.userData?.private ==  0{
                                UserData.setIsPrivate(isPrivate: false)
                            }else if response?.data?.userData?.private == 1{
                                UserData.setIsPrivate(isPrivate: true)
                            }
                            
                            UserData.setUserAvatar(avatar: response?.data?.userData?.image_url ?? "")
                            UserData.setUserId(userId: response?.data?.userData?.id ?? 0)
                            UserData.setUserName(userName: response?.data?.userData?.name ?? "")
                            
                            UserData.setFriendsCount(friendsCount: response?.data?.userData?.friends_count ?? 0)
                            
                            let uuid =  response?.data?.userData?.uuid ?? ""
                            
                            UserData.setUUID(userId: uuid)
                            
                            let uselful =  response?.data?.userData?.replys_useful_count ?? 0
                            
                            UserData.setUseful(uselful: uselful)
                            UserData.setUSER_EMAIL(email: response?.data?.userData?.email ?? "")
                            UserData.setUserphone(phone: response?.data?.userData?.phone ?? "")
                            
                            UserData.setapi_token(access_token: response?.data?.token ?? "")
                            UserData.setCountryCode(country_code:  response?.data?.userData?.country_code ?? "")
                            // store
                            UserData.isUserHasStore(user_hass_store: response?.data?.userData?.store ?? false)
                            var storeId = response?.data?.userData?.store_id ?? 0
                            UserData.setUserStoreId(user_storeId: storeId)
                            
                            if (storeId != 0 ){
                                UserData.isUserHasStore(user_hass_store: true)
                            }else {
                                UserData.isUserHasStore(user_hass_store: false)
                            }
                            // store activation state
                            if ((response?.data?.userData?.store == nil || !(response?.data?.userData?.store ?? false)) && storeId != 0 ){
                                
                                UserData.isStoreActive(isActive: false)
                                
                            }else if (response?.data?.userData?.store ?? false ){
                                
                                UserData.isStoreActive(isActive: true)
                                
                            }else if (!(response?.data?.userData?.store ?? false )){
                                
                                UserData.isStoreActive(isActive: false)
                            }

                            guard let self = self else {return}
                            
                           
                            
                        }
                        
                        
                    }else{
                        
                        if error != nil{
                            self.stopAnimation()
                            if error?.message == "Unauthorised"{
                                self.view.makeToast("Email or password not correct ")
                                
                            }else {
                                self.view.makeToast("Something went wrong")
                            }
                         
                        }else {
                          
                            self.stopAnimation()
                            self.view.makeToast("Something went wrong")
                            //                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func signUp(_ sender: Any) {
        
//        performSegue(withIdentifier: "toSignUp", sender: sender)

        
    }
    
    
    @IBAction func toForgetPassword(_ sender: Any) {
//        performSegue(withIdentifier: "toForgetPassword", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp"{
            
            
        }else if segue.identifier == "forgetPassword"{
            
            
        }else if segue.identifier == "Error"{
            
//            let errorVc = segue.destination as! ErrorViewController
//
//            errorVc.error = self.error ?? ""
            
        }
    }
    
    @IBAction func weChatLogin(_ sender: Any) {
        
        
//        let req = SendAuthReq()
//        req.scope = "snsapi_userinfo"//Important that this is the same
//        req.state = "123"//This can be any random value
//        WXApi.sendAuthReq(req, viewController: self, delegate: self)

    }
    
    func onReq(_ req: BaseReq) {
            print ("reqreqreq \(req)")
        }
    
    func onResp(_ resp: BaseResp) {
            print ("respresp \(resp)")
        }
    
    var appleLoginClear = true
    func checkUserForApple(app_id:String , name:String , email:String)  {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown,.offline:
            self.view.makeToast("No Internet Connection!")
        case .online(.wwan), .online(.wiFi):
            startAnimation()
            
            // Do something
           
    }
}

extension LoginVC:ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple auth failed")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential{
            
        case let credential as ASAuthorizationAppleIDCredential:
             appleUserIdentifier = credential.user ?? ""
            let firstName = credential.fullName?.givenName ?? "New"
            let familyName = credential.fullName?.familyName ?? "user"
             appleEmail = credential.email ?? ""
            
            print("givenName \(credential.fullName?.givenName)")
            
            print("userIdentifier \(appleUserIdentifier) firstName \(firstName) familyName \(familyName) email \(appleEmail)")
            
             appleFullName = "\(firstName) \(familyName)"
            print("fullName \(appleFullName)")
            //            apple_login
            
            checkUserForApple(app_id: appleUserIdentifier, name: appleFullName, email: appleEmail)
            
            break
        default:
            break
            
        }
    }
   
}
extension LoginVC:ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
