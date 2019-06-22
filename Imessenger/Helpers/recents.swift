//
//  recents.swift
//  Imessenger
//
//  Created by Ambar Kumar on 22/06/19.
//  Copyright © 2019 Ambar Kumar. All rights reserved.
//

import Foundation

func startPrivateChat(user1 : FUser, user2: FUser)-> String{
    
    let userId1 = user1.objectId
    let userId2 = user2.objectId
    
    var chatRoomId = ""
    
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        chatRoomId = userId1 + userId2
    }else{
        chatRoomId = userId2 + userId1
    }
    
    let members = [userId1 , userId2]
    
    //recents chats
    createRecents(members: members, chatRoomId: chatRoomId, withUserUserName: "", type: kPRIVATE,users: nil,avatarGroupChat: nil)
    
    return chatRoomId
}

func createRecents(members : [String],  chatRoomId : String, withUserUserName : String, type : String,
                   users : [FUser]?,avatarGroupChat : String?){
    
}
