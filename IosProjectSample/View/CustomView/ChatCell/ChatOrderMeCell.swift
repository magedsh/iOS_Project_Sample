//
//  ChatOrderMeCell.swift
//  LaowaiQuestions
//
//  Created by Macbook on 23/01/2023.
//  Copyright © 2023 Maged Shaheen. All rights reserved.
//

import UIKit

class ChatOrderMeCell: UITableViewCell {
    @IBOutlet weak var storeNameLb: UILabel!
    @IBOutlet weak var storeIv: Roundedimage!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func cellConfig(order:OrderModel?){

        storeNameLb.text = order?.store?.name ?? ""
        let imageURL = order?.store?.imageURL ?? ""
        let url = URL(string: imageURL)
        
        storeIv.kf.setImage(with: url)
//        orderPrice.text = "\(order?.total ?? 0)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
