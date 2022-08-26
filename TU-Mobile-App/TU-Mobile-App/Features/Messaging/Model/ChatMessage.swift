//
//  ChatMessage.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 2/4/22.
//

import Foundation
import Firebase

struct ChatMessage: Identifiable {
    
    var id: String {documentId}
    
    let documentId: String
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[firebaseConstants.fromId] as? String ?? ""
        self.toId = data[firebaseConstants.toId] as? String ?? ""
        self.text = data[firebaseConstants.text] as? String ?? ""
    }
}
