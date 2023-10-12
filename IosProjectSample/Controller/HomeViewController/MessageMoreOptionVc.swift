//
//  MessageMoreOptionVc.swift
//  LaowaiQuestions
//
//  Created by Macbook on 8/26/21.
//  Copyright © 2021 Maged Shaheen. All rights reserved.
//

import UIKit

protocol moreMessageOption {
    
    func setActionString(action:String)
}

class MessageMoreOptionVc: UIViewController {

    var delegate:moreMessageOption?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func blockClicked(_ sender: Any) {
        
        delegate?.setActionString(action: "block")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func reportClicked(_ sender: Any) {
        delegate?.setActionString(action: "report")
        dismiss(animated: true, completion: nil)


    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   
        self.dismiss(animated: true, completion: nil)
    }
   
}
