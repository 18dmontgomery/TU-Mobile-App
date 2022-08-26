//
//  CreateNewMessageView.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/30/21.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI

struct CreateNewMessageView: View {

    let didSelectNewUser: (ChatUser) -> ()
    @Environment(\.presentationMode) var presentationMode

    //@ObservedObject private var vm2 = MainMessagesViewModel()
    @ObservedObject var vm = CreateNewMessageViewModel()
    @ObservedObject var networkViewModel = NetworkViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)

                ForEach(vm.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack(spacing: 16) {
                            if (!user.profileImageUrl.isEmpty) {
                                WebImage(url: URL(string: user.profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(50)
                                    .overlay(RoundedRectangle(cornerRadius: 50)
                                                .stroke(Color(.label), lineWidth: 2)
                                    )
                            }
                            else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 44)
                                                .stroke(Color(.label), lineWidth: 1)
                                    )
                            }
                            Text("\(user.fName)" + " " + "\(user.lName)" )
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
}
