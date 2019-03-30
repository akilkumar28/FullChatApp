//
//  Recent.swift
//  FullChatApp
//
//  Created by AKIL KUMAR THOTA on 3/26/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import Foundation


func startPrivateChat(user1: FUser, user2: FUser) -> String {
    
    let user1Id = user1.objectId
    let user2Id = user2.objectId
    
    var chatRoomId = ""
    
    let value = user1Id.compare(user2Id).rawValue
    
    if value < 0 {
        chatRoomId = user1Id + user2Id
    } else {
        chatRoomId = user2Id + user1Id
    }
    let members = [user1Id,user2Id]
    
    createRecent(members: members, chatRoomId: chatRoomId, withUserUserName: "", type: kPRIVATE, users: [user1,user2], avatarOfGroup: nil)
    
    return chatRoomId
}

func createRecent(members:[String], chatRoomId:String, withUserUserName:String, type:String, users:[FUser]?, avatarOfGroup:String?) {
    
    var tempMembers = members
    reference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        if error != nil {
            print(error?.localizedDescription)
            return
        }
        guard let snapshot = snapshot else {return}
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let currentRecent = recent.data() as NSDictionary
                
                if let currentUserId = currentRecent[kUSERID] {
                    if tempMembers.contains(currentUserId as! String) {
                        tempMembers.remove(at: tempMembers.index(of: currentUserId as! String)!)
                    }
                }
            }
        }
        
        for userid in tempMembers {
            //create recent items
            createRecentItem(userId: userid, chatRoomId: chatRoomId, members: members, withUserUserName: withUserUserName, type: type, users: users, avatarOfGroup: avatarOfGroup)
        }
        
        
    }
    
    
}



func createRecentItem(userId:String,chatRoomId:String,members:[String],withUserUserName:String,type:String,users:[FUser]?,avatarOfGroup:String?) {
    
    
    let localReference = reference(.Recent).document()
    let recentId = localReference.documentID
    
    let date = dateFormatter().string(from: Date())
    
    var recent:[String:Any] = [:]
    
    if type == kPRIVATE {
        //private
        var withUser:FUser?
        if users != nil && users!.count > 0  {
            if userId == FUser.currentId() {
                withUser = users!.last!
            } else {
                withUser = users!.first!
            }
        }
        
        recent = [
            kRECENTID:recentId,
            kUSERID:userId,
            kCHATROOMID:chatRoomId,
            kMEMBERS:members,
            kMEMBERSTOPUSH:members,
            kWITHUSERUSERNAME:withUser!.fullname,
            kWITHUSERUSERID:withUser!.objectId,
            kLASTMESSAGE: "",
            kCOUNTER:0,
            kDATE:date,
            kTYPE:type,
            kAVATAR:withUser!.avatar
        ]
        
    } else {
        //group
        
        if avatarOfGroup != nil {
            recent = [
                kRECENTID:recentId,
                kUSERID:userId,
                kCHATROOMID:chatRoomId,
                kMEMBERS:members,
                kMEMBERSTOPUSH:members,
                kWITHUSERFULLNAME:withUserUserName,
                kLASTMESSAGE: "",
                kCOUNTER:0,
                kDATE:date,
                kTYPE:type,
                kAVATAR:avatarOfGroup
            ]
        }
    }
    
    
    localReference.setData(recent)
    
    
    
}


