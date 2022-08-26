//
//  TestProfileView.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/27/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct TestProfileView: View {
    
    @ObservedObject var networkViewModel: NetworkViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var userItem: FetchedUserModel
    let uid = Auth.auth().currentUser?.uid
    
    var body: some View {
        
        Text("Hello, \(userItem.fName)!")
        Text("Your unique ID is: \(userItem.id)")
        
        Button( action: {
            
//            self.networkViewModel.updateUserNetwork(currentUserID: uid!, withUserID: userItem.id)
            
            self.networkViewModel.updateUserNetwork2(currentUserID: uid!, withUser: userItem)
            
        }, label: {
            Text("Add to Network")
        })
        
        Button( action: {
            
//            self.networkViewModel.deleteUserNetwork(withUserID: userItem.id)
            self.networkViewModel.deleteUserNetwork2(withUser: userItem)
            
            
        }, label: {
            Text("Delete from Network")
        })
        
    }
}
