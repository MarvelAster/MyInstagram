//
//  UserComments.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/31/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import Foundation
struct Comment {
    var commentId : String
    var commentDetail : CommentDetail
}
struct CommentDetail {
    var userId : String
    var postId : String
    var commentText : String
}
