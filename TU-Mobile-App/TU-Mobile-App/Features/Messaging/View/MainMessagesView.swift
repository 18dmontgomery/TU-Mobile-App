//
//  MainMessagesView.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/29/21.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct MainMessagesView: View {

    @Environment(\.presentationMode) var presentationMode
    @State var shouldShowLogOutOptions = false
    @State var shouldNavigateToChatLogView = false
    @State var shouldShowNewMessageScreen = false
    @State var chatUser: ChatUser?
    @State var openMessages = false
    
    
    @ObservedObject private var vm = MainMessagesViewModel()
    @ObservedObject var FetchUsersvm = CreateNewMessageViewModel()
    
    private var chatLogViewModel = ChatLogViewModel(chatUser: nil)

    var body: some View {
        //NavigationView {

            VStack {
                customNavBar
                messagesView
                
                NavigationLink(destination: ChatLogView(vm: chatLogViewModel), isActive: $shouldNavigateToChatLogView) {
                                    Text("")
                }
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarTitle("Messaging")
            //.navigationBarHidden(true)
       // }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            WebImage(url: URL(string:
                vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(vm.chatUser?.fName ?? "")" + " " + "\(vm.chatUser?.lName ?? "")" )
                    .font(.system(size: 24, weight: .bold))

                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }

            }

            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
                //isChatButtonPressed.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                }),
                    .cancel()
            ])
        }
    }


    private var messagesView: some View {
        ScrollView {
            ForEach(vm.recentMessages) { recentMessage in
                VStack {
                    NavigationLink(destination: ChatLogView(vm: chatLogViewModel), isActive: $openMessages) {
                        Button {
                            let uid = FirebaseManager.shared.auth.currentUser?
                                .uid == recentMessage.fromId ?
                                recentMessage.toId : recentMessage.fromId
                            self.chatUser = .init(data:
                                                    [firebaseConstants.fname:
                                                        recentMessage.fname,
                                                     firebaseConstants.lname:
                                                         recentMessage.lname,
                                                     firebaseConstants.email:
                                                        recentMessage.email,
                                                     firebaseConstants.profileImageUrl:
                                                        recentMessage.profileImageUrl,
                                                     firebaseConstants.uid: uid])
                            openMessages.toggle()
                            self.chatLogViewModel.chatUser = self.chatUser
                            self.chatLogViewModel.fetchMessages()
                            //vm.recentMessages = user
                            //presentationMode.wrappedValue.dismiss()
                        } label: {

                                HStack(spacing: 16) {
                                    if (!recentMessage.profileImageUrl.isEmpty) {
                                        WebImage(url: URL(string: recentMessage.profileImageUrl))
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
                                    VStack(alignment: .leading) {
                                        Text("\(recentMessage.fname)" + " " + "\(recentMessage.lname)")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color(.label))
                                            .multilineTextAlignment(.leading)
                                        Text(recentMessage.text)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(.darkGray))
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    
                                    Text(recentMessage.timeAgo)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(.label))
                                }
                        }
                }
                    
                        
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)

            }.padding(.bottom, 50)
        }
    }
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            CreateNewMessageView(didSelectNewUser: { user in
                self.shouldNavigateToChatLogView.toggle()
                self.chatUser = user
                self.chatLogViewModel.chatUser = user
                self.chatLogViewModel.fetchMessages()
                
                
            })
        }
    }
}
