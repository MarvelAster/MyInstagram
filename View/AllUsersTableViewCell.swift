//
//  AllUsersTableViewCell.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/26/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
protocol AllUserCellDelegate {
    func addFriendWithUser(cell : AllUsersTableViewCell)
}
class AllUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var toplbl: UILabel!
    @IBOutlet weak var bottomlbl: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    var delegate : AllUserCellDelegate!
    
    @IBAction func plusBtnClick(_ sender: Any) {
        delegate.addFriendWithUser(cell: self)
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
