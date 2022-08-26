//
//  NetworkViewModel.swift
//  TU-Mobile-App
//
//  Created by Boone on 10/21/21.
//
import Combine
import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwiftTarget
import FirebaseFirestoreSwift

class NetworkViewModel: ObservableObject {
  
    @Published var network: [Network]
    @Published var users: [FetchedUserModel]
    @Published var testNetwork: [TestNetworkModel]
    @Published var allUsersInDatabase: [FetchedUserModel]
  
    init() {
    
        network = [Network(id: "", thumbnail: "dummy"),
               Network(id: "", thumbnail: "dummyBlue"),
               Network(id: "", thumbnail: "dummyRed"),
               Network(id: "", thumbnail: "dummyGreen"),
               Network(id: "", thumbnail: "dummyPurple")]
        
        users = []
        testNetwork = []
        allUsersInDatabase = []
    }
    
    func getAllUsersByMajor(userMajor: String) {
        print("Attempting to fetch all users by major: \(userMajor)...")
        
        let db = Firestore.firestore()
        
        //Attempt to fetch users by field: "major" from Firebase
        // "userMajor" is a hardcoded value from "ExploreView.swift"
        db.collection("users").whereField("major", isEqualTo: userMajor).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents for field -> major.")
                return
            }
            
            print("Attemption to fetch users by major...")
            
//            Store information fetched into the UserModel.swift file to be accessed on views
            self.users = documents.map { queryDocumentSnapshot -> FetchedUserModel in
                let data = queryDocumentSnapshot.data()
                let fName = data["firstName"] as? String ?? ""
                let lName = data["lastName"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let classYear = data["class"] as? String ?? ""
                let major = data["major"] as? String ?? ""
                let minor = data["minor"] as? String ?? ""
                let id = data["uid"] as? String ?? ""
                let profileImageurl = data["profileImageurl"] as? String ?? ""

                return FetchedUserModel(id: id, fName: fName, lName: lName, gender: gender, classYear: classYear, major: major, minor: minor, profileImageUrl: profileImageurl)

            }
            print(self.users)
        
        }
        
    }
    
//    func readNetworkItems() {
//        
//        let db = Firestore.firestore()
//        
//        let user = Auth.auth().currentUser!.uid
//        let refToRead = db.collection("users").document(user)
//        refToRead.getDocument(completion: { documentSnapshot, error in
//            if let err = error {
//                 print(err.localizedDescription)
//                 return
//             }
//
//            if let doc = documentSnapshot {
//                //let users = doc.get("users") as! String
//                let network = doc.get("network") as! [String]
//                //print(users)
//                for item in network {
//                    print(item)
//                }
//            }
//        })
//    }
    
//    func getUsersInCurrentUsersNetwork(currentUserID: String) {
//        print("Attempting to fetch all users in network...")
//
//        let db = Firestore.firestore()
//
//        //Attempt to fetch users by field: "major" from Firebase
//        // "userMajor" is a hardcoded value from "ExploreView.swift"
//        db.collection("users").document(currentUserID).
//        db.collection("users").whereField("network").addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("No documents for field -> uid.")
//                return
//            }
//
////            Store information fetched into the UserModel.swift file to be accessed on views
//            self.testNetwork = documents.map { queryDocumentSnapshot -> TestNetworkModel in
//                let data = queryDocumentSnapshot.data()
//                let network = data["network"] as? [String] ?? []
//
//                return TestNetworkModel(network: network)
//
//            }
//
//        }
//    }
    
    
    //Get all users in Logged-In User's Network
    func getAllUsersInNetwork(currentUserID: String) {
        print("Attempting to fetch all users in network...")

        let db = Firestore.firestore()

        //Attempt to fetch users by field: "major" from Firebase
        // "userMajor" is a hardcoded value from "ExploreView.swift"
        db.collection("users").whereField("uid", isEqualTo: currentUserID).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents for field -> uid.")
                return
            }

//            Store information fetched into the UserModel.swift file to be accessed on views
            self.testNetwork = documents.map { queryDocumentSnapshot -> TestNetworkModel in
                let data = queryDocumentSnapshot.data()
                let network = data["network"] as? [String] ?? []

                return TestNetworkModel(network: network)

            }

        }
    }

    //MARK: TODO - This "data(as: ...)" function only works with Pods. Swift Package Manager doesn't have the function in its codebase. This would be an easier implementation to fetch the data rather than above. A third party package dependency might be needed to get this working... Not of high importance; just a thought.
//    func fetchData() {
//        let db = Firestore.firestore()
//
//        db.collection("users").addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("no documents")
//                return
//            }
//
//            self.users = documents.compactMap { queryDocumentSnapshot -> TestUserModel? in
//                return try? queryDocumentSnapshot.data(as: TestUserModel.self)
//
//            }
//
//        }
//    }
    
    func updateUserNetwork2(currentUserID: String, withUser: FetchedUserModel) {
        print("Attempting to add - \(withUser) - to network...")
        
        let db = Firestore.firestore()
        
        do {
            let jsonData = try JSONEncoder().encode(withUser)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            db.collection("users").document(currentUserID).updateData(["network": FieldValue.arrayUnion([jsonObject])])
        } catch {
            print("an error occured")
        }

    }
    
    func deleteUserNetwork2(withUser: FetchedUserModel) {
        print("Attempting to delete - \(withUser) - from network...")
        
        let db = Firestore.firestore()
        
        do {
            let jsonData = try JSONEncoder().encode(withUser)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["network": FieldValue.arrayRemove([jsonObject])])
        } catch {
            print("an error occured")
        }

    }
    
    
    func getAllUsers() {
        print("Attempting to fetch all users...")
        
        let db = Firestore.firestore()
        
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents for field -> major.")
                return
            }
            
            print("Attemption to fetch users...")
            
//            Store information fetched into the UserModel.swift file to be accessed on views
            self.allUsersInDatabase = documents.map { queryDocumentSnapshot -> FetchedUserModel in
                let data = queryDocumentSnapshot.data()
                let fName = data["firstName"] as? String ?? ""
                let lName = data["lastName"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let classYear = data["class"] as? String ?? ""
                let major = data["major"] as? String ?? ""
                let minor = data["minor"] as? String ?? ""
                let id = data["uid"] as? String ?? ""
                let profileImageurl = data["profileImageurl"] as? String ?? ""

                
                //print(self.users)
                return FetchedUserModel(id: id, fName: fName, lName: lName, gender: gender, classYear: classYear, major: major, minor: minor, profileImageUrl: profileImageurl)

            }
        
        }
        
    }
  
}
