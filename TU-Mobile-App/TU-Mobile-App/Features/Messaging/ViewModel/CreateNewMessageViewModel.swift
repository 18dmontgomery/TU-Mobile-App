//
//  CreateNewMessageViewModel.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 2/4/22.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI

class CreateNewMessageViewModel: ObservableObject {

    @Published var users = [ChatUser]()
    @Published var errorMessage = ""

    init() {
        fetchAllUsers()
    }

    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }

                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(data: data)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(.init(data: data))
                    }

                })
            }
    }
}
