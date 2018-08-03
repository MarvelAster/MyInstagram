//
//  CommentTableViewCell.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/31/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
