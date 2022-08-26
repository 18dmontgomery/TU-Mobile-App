//
//  LoginViewModel.swift
//  TU-Mobile-App
//
//  Created by Ebrahim Obaid on 11/9/21.
//
import Combine
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class LoginViewModel: ObservableObject {

    @Published var email: String
    @Published var password: String

    @Published var alert : Bool
    @Published var error : String

    init() {

        email = ""
        password = ""

        alert = false
        error = ""

    }

    func loginUser() {

            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Failed to login user:", err)
                    self.error = "Failed to login user: \(err)"
                    self.alert.toggle()

                    return
                } else {

                    print("Successfully logged in as user: \(result?.user.uid ?? "")")
                    self.error = "Successfully logged in as user: \(result?.user.uid ?? "")"

                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"),
                                                    object: nil)

                }

            }
        }

    func verify() {

        if self.email != "" && self.password != "" {

            loginUser()

        } else {

            self.error = "Please fill all the contents"
            self.alert.toggle()
        }

    }

    func signOut() {

        try! Auth.auth().signOut()
        UserDefaults.standard.set(false, forKey: "status")
        NotificationCenter.default.post(name: NSNotification.Name("status"),
                                        object: nil)
    }

}
