//  UsersViewModel.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/9/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import Firebase

class UsersViewModel: ObservableObject {

    @Published var names = [UserModel]()
    private var db = Firestore.firestore()

    func fetchData(){
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

                self.names = documents.map { (queryDocumentSnapshot) -> UserModel in
                let data = queryDocumentSnapshot.data()

                let classes = data["class"] as? String ?? ""
                let fname = data["firstname"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let lname = data["lastname"] as? String ?? ""
                let major = data["major"] as? String ?? ""
                let profilePic = data["profileImageUrl"] as? String ?? ""

                print(classes)

                    return UserModel(classes: classes, fname: fname, gender: gender, lname: lname, major: major, profileImageUrl: profilePic)
                //return user


            }
        }
    }

}
