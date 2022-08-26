//
//  CreateAccountViewModel.swift
//  TU-Mobile-App
//
//  Created by Ebrahim Obaid on 11/9/21.
//
import Combine
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CreateAccountViewModel: ObservableObject {
    
    @Published var email: String
    @Published var password: String
    @Published var confirmPassword: String
    @Published var firstName: String
    @Published var lastName: String
    @Published var gender: String
    @Published var classYear: String
    @Published var major: String
    @Published var minor: String
    @Published var interests: [String]
    
    @Published var alert : Bool
    @Published var error : String
    
    init() {
    
        email = ""
        password = ""
        confirmPassword = ""
        firstName = ""
        lastName = ""
        gender = ""
        classYear = ""
        major = ""
        minor = ""
        interests = []
        
        alert = false
        error = ""
    }
    
    func createNewAccount(userEmail: String, userPassword: String, firstName: String,
                          lastName: String, gender: String, classYear: String, major: String, minor: String, interests: [String]) {
        
        FirebaseManager.shared.auth.createUser(withEmail: userEmail, password: userPassword) { result, err in
            
            if let err = err {
                print("Failed to create user:", err)
                self.error = "Failed to create user: \(err)"
                self.alert.toggle()
                
                return
            }

            print("Successfully created user: \(result?.user.uid ?? "")")
            self.error = "Successfully created user: \(result?.user.uid ?? "")"
            
            let db = Firestore.firestore()
            
            // Add a new document with a generated id.
            let newUserReference = db.collection("users").document(result?.user.uid ?? "")
            
            newUserReference.setData([
                "firstName": firstName,
                "lastName": lastName,
                "email": userEmail,
                "gender": gender,
                "class": classYear,
                "major": major,
                "minor": minor,
                "uid": result?.user.uid ?? "Error. Check CreateAccountViewModel.swift",
                "interests": interests
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(result?.user.uid ?? "")")
                }
            }
            
            UserDefaults.standard.set(true, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"),
                                            object: nil)
        }
    }
    
    func register() {
        
        if self.email != "" {
            
            if self.password == self.confirmPassword {
            
//                createNewAccount()
                
            } else {
                
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        } else {
            
            self.error = "Please fill all the contents"
            self.alert.toggle()
        }
    }
    
}

