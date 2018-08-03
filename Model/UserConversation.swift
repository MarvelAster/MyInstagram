//
//  UserConversation.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 6/4/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import Foundation
struct Conversation {
    var conversationId : String
    var conversationDetail : [ConversationDetail]
}
struct ConversationDetail {
    var timestamp : String
    var message : String
    var sendId : String
}
