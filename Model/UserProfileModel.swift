//
//  UserProfileModel.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/25/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import Foundation
struct UserInfo {
    var userId : String
    var user : User
}
struct User {
    var Name : String
    var EmailId : String
    var PhoneNumber : String
    var UserImage : String
    var posts: [String : String] = [:]
    var following: [String : String] = [:]
    var followers: [String : String] = [:]
    var friends : [String : String] = [:]
    
}


