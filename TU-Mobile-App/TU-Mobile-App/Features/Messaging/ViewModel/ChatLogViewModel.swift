//
//  ChatLogViewModel.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 2/4/22.
//

import Foundation
import SwiftUI
import Firebase

struct firebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let fname = "fname"
    static let lname = "lname"
    static let profileImageUrl = "profileImageUrl"
    static let uid = "uid"
    static let email = "email"

}

class ChatLogViewModel: ObservableObject {

    @Published var count = 0
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    @Published var chatMessages = [ChatMessage]()

    var chatUser: ChatUser?

    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    var firestoreListener: ListenerRegistration?
    
    func fetchMessages() {
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener {querySnapshot, error in
                if let error  = error {
                    self.errorMessage = "Failed to listen for messages:\(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                
                DispatchQueue.main.async {
                    self.count+=1
                }
            }
    }

    func handleSend() {
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }

        guard let toId = chatUser?.uid else { return }

        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
       // let newUserReference = db.collection("users").document(result?.user.uid ?? "")
        
        let messageData = [firebaseConstants.fromId: fromId, firebaseConstants.toId: toId, firebaseConstants.text: self.chatText, firebaseConstants.timestamp: Timestamp()] as [String : Any]
        
        let notif = FirebaseManager.shared.firestore.collection("notifications")
            .document(fromId)
            .collection(toId)
            .document()
        
        notif.setData(["work": "yes"])  { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
        

        document.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }

            print("Successfully saved current user sending message")
            
            self.persistRecentMessages()
            self.chatText = ""
            self.count+=1
        }

        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()

        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }

            print("Recipient saved message as well")
        }
    }
    
    private func persistRecentMessages() {
        
        guard let chatUser = chatUser else { return }

                guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
                guard let toId = self.chatUser?.uid else { return }

                let document = FirebaseManager.shared.firestore
                    .collection("recent_messages")
                    .document(uid)
                    .collection("messages")
                    .document(toId)

                let data = [
                    firebaseConstants.timestamp: Timestamp(),
                    firebaseConstants.text: self.chatText,
                    firebaseConstants.fromId: uid,
                    firebaseConstants.toId: toId,
                    firebaseConstants.fname: chatUser.fName,
                    firebaseConstants.lname: chatUser.lName,
                    firebaseConstants.profileImageUrl: chatUser.profileImageUrl,
                    firebaseConstants.email: chatUser.email
                ] as [String : Any]

                // you'll need to save another very similar dictionary for the recipient of this message...how?

                document.setData(data) { error in
                    if let error = error {
                        self.errorMessage = "Failed to save recent message: \(error)"
                        print("Failed to save recent message: \(error)")
                        return
                    }
                }

        guard let currentUser = FirebaseManager.shared.auth.currentUser else { return }
                let recipientRecentMessageDictionary = [
                    firebaseConstants.timestamp: Timestamp(),
                    firebaseConstants.text: self.chatText,
                    firebaseConstants.fromId: uid,
                    firebaseConstants.toId: toId,
                    firebaseConstants.fname: chatUser.fName,
                    firebaseConstants.lname: chatUser.lName,
                    firebaseConstants.profileImageUrl: chatUser.profileImageUrl,
                    firebaseConstants.email: chatUser.email
                ] as [String : Any]

                FirebaseManager.shared.firestore
                    .collection("recent_messages")
                    .document(toId)
                    .collection("messages")
                    .document(currentUser.uid)
                    .setData(recipientRecentMessageDictionary) { error in
                        if let error = error {
                            print("Failed to save recipient recent message: \(error)")
                            return
                    }
                }
        }
    
}
