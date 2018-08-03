//
//  UserPostModel.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/29/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import Foundation
import UIKit
struct UserPost {
    var postId: String
    var postDetai : PostDetail
}

struct PostDetail {
    var description : String
    var imageRef : String
    var like : Int
    var timestamp : Double
    var userId : String
    var postImage : UIImage?
    var postUserImage : UIImage?
    var name : String?
    var isLike : Bool
    var likeby : [String : String]
    var commentby : [String : String]
}
