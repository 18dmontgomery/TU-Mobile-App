//
//  FirebaseServices.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/13/21.
//
import Combine
import SwiftUI
import Foundation
import Firebase
import FirebaseAuth

class FirebaseServices {
    
    var result: Any = ""

    func retrieveFromDB(collectionName: String, variableName: String, completion:  @escaping (Result<Any, Error>) -> Void) {

        guard let uid = Auth.auth().currentUser?.uid else {
    //            completion(.failure(FirebaseError.notLoggedIn))
            return
        }

        let group = DispatchGroup()

        print("starting async call...")

        group.enter()

        let db = Firestore.firestore().collection(collectionName)
        let docRef = db.document(uid)

        docRef.getDocument { (snapshot, error) in
            if let error = error {
                print(error)
                completion(.failure(error))
                group.leave()
                return
            }
            self.result = snapshot?.get(variableName) ?? "error retrieving data"

            group.leave()
        }


        group.notify(queue: DispatchQueue.global(qos: .background)) {
            print("all names returned, we can continue")
            completion(.success(self.result))
        }

    }

    func retrieveUserProperty(variableName: String, completion: @escaping (Result<String, Error>) -> Void) {
            retrieveFromDB(collectionName: "users", variableName: variableName, completion: { result in
                switch result {
                case .success(let value):
                    let username = value as? String
                    if username != nil{
                        completion(.success(username!))
                    } else {
                        print("username = nil")
                    }
                    return
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            })
        }

    func retrieveLName (completion: @escaping (Result<String, Error>) -> Void) {
            print(#function)
            retrieveUserProperty(variableName: "lastName", completion: completion)
        }
    func retrieveClassNumber (completion: @escaping (Result<String, Error>) -> Void) {
            print(#function)
            retrieveUserProperty(variableName: "class", completion: completion)
        }
    func retrieveProfilePicture (completion: @escaping (Result<String, Error>) -> Void) {
            print(#function)
            retrieveUserProperty(variableName: "profileImageUrl", completion: completion)
    }

    func retrieveName(completion: @escaping (Result<String, Error>) -> Void) {
        retrieveUserProperty(variableName: "firstName", completion: completion)
    }

    func retrieveMajor(completion: @escaping (Result<String, Error>) -> Void) {
        retrieveUserProperty(variableName: "major", completion: completion)
    }
    
}
