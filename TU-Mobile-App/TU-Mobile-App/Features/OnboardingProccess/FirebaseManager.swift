//
//  FirebaseManager.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/13/21.
//

import Combine
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import SwiftUI

class FirebaseManager: NSObject {

    let auth: Auth
    let storage: Storage
    let firestore: Firestore

    static let shared = FirebaseManager()

    override init() {
      
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

      self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()

      super.init()
      
    }

}
