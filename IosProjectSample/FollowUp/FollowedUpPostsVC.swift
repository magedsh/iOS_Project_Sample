//
//  FollowedUpPostsVC.swift
//  IosProjectSample
//
//  Created by Maged on 13/10/2023.
//  Copyright © 2023 Maged Shaheen. All rights reserved.
//

import UIKit


class FollowedUpPostsVC: UIViewController {
    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var tableView: UITableView!
    let pulltoRefresh = UIRefreshControl()
    @IBOutlet weak var emptylb: UILabel!
    var postsList:[Post] = [Post]()
    var percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition!
    var panGestureRecognizer: UIPanGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()

        emptylb.isHidden = true
        initIndicator()
        setupUI()
        getSavedPosts()
        addGesture()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addGesture() {
        guard navigationController?.viewControllers.count > 1 else {
            return
        }
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Followed up Posts"
        navigationController?.navigationBar.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        let percent = max(panGesture.translation(in: view).x, 0) / view.frame.width
                switch panGesture.state {
        case .began:
            navigationController?.delegate = self
            _ = navigationController?.popViewController(animated: true)
            
        case .changed:
            if let percentDrivenInteractiveTransition = percentDrivenInteractiveTransition {
                percentDrivenInteractiveTransition.update(percent)
            }
            
        case .ended:
            let velocity = panGesture.velocity(in: view).x
            // Continue if drag more than 50% of screen width or velocity is higher than 1000
            if percent > 0.5 || velocity > 1000 {
                percentDrivenInteractiveTransition.finish()
            } else {
                percentDrivenInteractiveTransition.cancel()
            }
            
        case .cancelled, .failed:
            percentDrivenInteractiveTransition.cancel()
            
        default:
            break
        }
    }
    
    var page = 1
    
    func getSavedPosts()  {
        let status = Reach().connectionStatus()
        switch status {
         
          case .unknown, .offline:
  //            ZKProgressHUD.dismiss()
                  
              self.view.makeToast("Internet Connection Failed")
        
          case .online(.wwan), .online(.wiFi):
            
              ServiceManger.instance.getFollowedUpPosts(page: page){ (response) in  // get followed up
                
               DispatchQueue.main.async { [weak self] in
                     
                   guard let self = self else {return}

                      if (response != nil){
                          
                          let page = self.page ?? 1
                          self.page = page + 1
                          
                          if response?.data?.nextPageURL == nil {
                              
                              self.isNextPageAvailable = false
                              
                          }else {
                              self.isNextPageAvailable = true
                              
                          }

                      

                        
                          for (index , post) in savedPosts!.data!.enumerated() {
                      
                              if (post.post != nil){
                                  self.postsList.append(post.post! )
                              }
                              
                          }
                        
                        
                        
                        if self?.postsList.count == 0{
                            self.emptylb.isHidden = false
                        }else {
                            self.emptylb.isHidden = true
                        }
                          self.tableView.reloadData()

                          
                          DispatchQueue.main.asyncAfter(deadline: .now() +  2.0) {
                              self.tableView.reloadData()
                              self.tableView.isHidden = false
                              self.stopAnimation()
                              self.indicator.isHidden = true
                              
                              self.spinner.stopAnimating()
                              self.pulltoRefresh.endRefreshing()

                          }

                      }else{
                          self.view.makeToast("Something gone wrong")

                      }
                }
          }
        }
        
    }
    
    @objc func refresh(){
        postsList.removeAll()

        page = 1

        getSavedPosts()
        
        tableView.reloadData()
        
    }
    
    @IBAction func back(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)

    }
    
    func setupUI(){

        startAnimation()

        pulltoRefresh.tintColor = #colorLiteral(red: 0.07450980392, green: 0.6235294118, blue: 0.8980392157, alpha: 1)
            
        pulltoRefresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tableView.addSubview(pulltoRefresh)
        tableView.backgroundColor =  #colorLiteral(red: 0.955743134, green: 0.9560872912, blue: 0.973654449, alpha: 1)

        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        emptylb.isHidden = true
        tableView.isHidden = true


        tableView.register(UINib(nibName: "HomeHeaderCellTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeHeaderCellTableViewCell")
      

        tableView.register(UINib(nibName: "NormalPostTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalPostTableViewCell")
        
        
        tableView.register(UINib(nibName: "ImageQuestTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageQuestTableViewCell")
        tableView.register(UINib(nibName: "TwoImagesQuestCell", bundle: nil), forCellReuseIdentifier: "TwoImagesQuestCell")

        tableView.register(UINib(nibName: "QuestionPostCell", bundle: nil), forCellReuseIdentifier: "QuestionPostCell")

        tableView.register(UINib(nibName: "GeneralPostTableViewCell", bundle: nil), forCellReuseIdentifier: "GeneralPostTableViewCell")
        tableView.register(UINib(nibName: "postCell", bundle: nil), forCellReuseIdentifier: "postCell")

    }
    var isNextPageAvailable = true

    let spinner = UIActivityIndicatorView(style: .gray)

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
}

extension FollowedUpPostsVC :  UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return postsList.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = self.postsList[indexPath.row]
       
        var cell = UITableViewCell()
        let images = post.images?.count  ?? 0
        if images  == 0 {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! postCell
            
            let cell = cell as? postCell
            cell?.bind(vc: self,post: post,index: indexPath.row, tableView: self.tableView, postsList: postsList)
    
            return cell ?? UITableViewCell()
            
        }else if images == 1 {
                        
            cell = tableView.dequeueReusableCell(withIdentifier: "ImageQuestTableViewCell") as! ImageQuestTableViewCell
            
            let cell = cell as? ImageQuestTableViewCell
            cell?.bind(vc: self,post: post,index: indexPath.row, tableView: self.tableView)
    
            return cell ?? UITableViewCell()
        }else if images >= 2 {
                      
            cell = tableView.dequeueReusableCell(withIdentifier: "TwoImagesQuestCell") as! TwoImagesQuestCell
            
            let cell = cell as? TwoImagesQuestCell
            cell?.bind(vc: self,post: post,index: indexPath.row, tableView: self.tableView)
    
            return cell ?? UITableViewCell()
            
        }
        
        else {
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
        if self.postsList.count >= 20 {
            
            if (isNextPageAvailable){
                
                let count = self.postsList.count
                let lastElement = count - 1
                
                if indexPath.row == lastElement {
                    
                    
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                    
                    self.tableView.tableFooterView = spinner
                    
                    self.tableView.tableFooterView?.isHidden = false
                    
                    self.getSavedPosts()
                    
                    
                }
            }else {
                self.tableView.tableFooterView?.isHidden = true

            }
        }
    }
    
    
    

}





extension FollowedUpPostsVC: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SlideAnimatedTransitioning()
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        navigationController.delegate = nil
        
        if panGestureRecognizer.state == .began {
            percentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
            percentDrivenInteractiveTransition.completionCurve = .easeOut
        } else {
            percentDrivenInteractiveTransition = nil
        }
        
        return percentDrivenInteractiveTransition
    }
}
