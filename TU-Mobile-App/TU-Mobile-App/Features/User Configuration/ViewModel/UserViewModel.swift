//
//  UserViewModel.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/13/21.
//
import Combine
import SwiftUI
import Foundation
import Firebase
import FirebaseAuth

class UserViewModel: ObservableObject {
    
//    @Published var user: UserModels = UserModels()
    
    @Published var currentUser: CurrentUserModel
    
    init() {
//        getName()
//        getMajor()
        
        currentUser = CurrentUserModel(fName: "", lName: "", gender: "", classYear: "", major: "", minor: "", profileImageUrl: "", network: [FetchedUserModel(fName: "", lName: "", gender: "", classYear: "", major: "", minor: "", profileImageUrl: "")], interests: [])
    }
    
    //Retrieves the current User's Information and stores it into "CurrentUserModel.swift"
    func getCurrentUser(userID: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error as NSError? {
                print("error receiving docs")
            } else {
                if let document = document {
                    let id = document.documentID
                    let data = document.data()
                    let fName = data?["firstName"] as? String ?? ""
                    let lName = data?["lastName"] as? String ?? ""
                    let gender = data?["gender"] as? String ?? ""
                    let classYear = data?["class"] as? String ?? ""
                    let major = data?["major"] as? String ?? ""
                    let minor = data?["minor"] as? String ?? ""
                    let profileImageUrl = data?["profileImageUrl"] as? String ?? ""
                    let network = data?["network"] as? [FetchedUserModel] ?? []
                    let interests = data?["interests"] as? [String] ?? []
                    self.currentUser = CurrentUserModel(id: id, fName: fName, lName: lName, gender: gender, classYear: classYear, major: major, minor: minor, profileImageUrl: profileImageUrl, network: network, interests: interests)
                  }
            }
        }
        
    }
    
//    func getName() {
//        FirebaseServices().retrieveName(completion: {result in
//            switch result {
//            case .success(let name):
//                self.user.fName = name
//            case .failure(let error):
//                print(error)
//            }
//        })
//    }
//
//    func getMajor() {
//
//        FirebaseServices().retrieveMajor(completion: { result in
//            switch result {
//            case .success(let major):
//                self.user.major = major
//            case .failure(let error):
//                print(error)
//            }
//        })
//    }
}
