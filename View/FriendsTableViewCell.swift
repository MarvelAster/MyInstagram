    //
//  FollowingTableViewCell.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 6/2/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
protocol FriendsCellDelegate {
    func removeFriendWithUser(cell : FriendsTableViewCell)
}
class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var delegate : FriendsCellDelegate!
    
    @IBAction func minusClick(_ sender: Any) {
        delegate.removeFriendWithUser(cell: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
