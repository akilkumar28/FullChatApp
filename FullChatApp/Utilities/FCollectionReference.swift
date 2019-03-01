//
//  FCollectionReference.swift
//  FullChatApp
//
//  Created by Akil Kumar Thota on 3/1/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}


func reference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}

