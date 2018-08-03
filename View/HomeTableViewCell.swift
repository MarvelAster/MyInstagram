//
//  HomeTableViewCell.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/29/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
protocol HomeTableViewDelegate {
    func likeBtnTapped(cell : HomeTableViewCell)
    func likeCountTapped(cell : HomeTableViewCell)
    func commentBtnTapped(cell : HomeTableViewCell)
    func followBtnTapped(cell : HomeTableViewCell)
    func postImgTapped(cell : HomeTableViewCell)
}
class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    var delegate : HomeTableViewDelegate?
    
    
    @IBAction func likeBtnClick(_ sender: Any) {
        delegate?.likeBtnTapped(cell: self)
    }
    @IBAction func commentClick(_ sender: Any) {
        delegate?.commentBtnTapped(cell: self)
    }
    @IBAction func followClick(_ sender: Any) {
        delegate?.followBtnTapped(cell: self)
    }
    
    func singleTapSet() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
        likeCount.isUserInteractionEnabled = true
        likeCount.addGestureRecognizer(singleTap)
    }
    @objc func singleTapAction() {
        delegate?.likeCountTapped(cell: self)
    }
    
    @objc func handleZoomTap(tapGesture : UITapGestureRecognizer) {
        delegate?.postImgTapped(cell: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        singleTapSet()
        self.postImg.isUserInteractionEnabled = true
        self.postImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
