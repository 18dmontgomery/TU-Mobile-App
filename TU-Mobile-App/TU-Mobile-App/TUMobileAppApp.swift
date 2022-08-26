//
//  TUMobileAppApp.swift
//  TUMobileApp
//
//  Created by Boone on 9/29/21.
//

import SwiftUI
import Firebase

@main
struct TUMobileAppApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        
        WindowGroup {
//          HomeView(courseViewModel: CourseViewModel(), networkViewModel: NetworkViewModel())
          
            OnboardingView(loginViewModel: LoginViewModel())
            //InterestsView(modalViewModel: ModalViewModel())
            
        //    MainMessagesView()

//          TabBar()
        }
    }
}
