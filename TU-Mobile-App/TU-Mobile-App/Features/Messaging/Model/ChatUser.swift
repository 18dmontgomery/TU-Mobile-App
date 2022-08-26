//
//  ChatUser.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/29/21.
//

import Foundation

struct ChatUser: Identifiable {
    var id: String { uid }

    let uid, email, profileImageUrl, fName, lName: String

    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.fName = data["firstName"] as? String ?? ""
        self.lName = data["lastName"] as? String ?? ""
        //self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        
    }

}

