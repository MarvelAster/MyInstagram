//
//  ChatWithFriendTableViewCell.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 6/4/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit

class ChatWithFriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chatText: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
