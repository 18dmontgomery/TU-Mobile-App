//
//  ClickedProfileView.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 12/4/21.
//

import SwiftUI
import SDWebImageSwiftUI

import Firebase
import FirebaseAuth

struct ClickedProfileView: View {
    
    @ObservedObject var courseViewModel: CourseViewModel
    @ObservedObject var networkViewModel: NetworkViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var userItem: FetchedUserModel
    
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var isCanceledClicked = false
    @State var isImageSelected = false
    @State var chatUser: ChatUser?
    
    @State var following: Int = 28
    
    
    var body: some View {
        ZStack {
            VStack {
                //CurvedSideRectangles()
                //UI Background RoundedRectangle
                RoundedRectangle(cornerSize: CGSize(width: 30, height: 20))
                    .foregroundColor(Color("Custom Color"))
                    .frame(height: 270.0)
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            
            VStack {
                VStack {
                    //Profile Rounded Rectangle
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                        .foregroundColor(.white)
                        .frame(width: 360, height: 240, alignment: .center)
                        .padding(.bottom, 525)
                        //.offset(y: -260)
                        .shadow(radius: 10)
                        .overlay(ClickedUserImageView(shouldShowImagePicker: $shouldShowImagePicker, image: $image, isImageSelected: $isImageSelected, userItem: userItem))
                        .overlay(ClickedUserNameView(userItem: userItem))
                        .overlay(ClickedUserFollowersView(following: $following))
                        .overlay(ClickedUserProfileButtons(networkViewModel: networkViewModel, userItem: userItem, following: $following))
                }
            }
            //BIO Rounded Rectangle
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .fill(
                    LinearGradient(gradient: Gradient(colors: [Color("StartBioColor"), Color("EndBioColor")]), startPoint: .leading, endPoint: .trailing)
                )
                //.foregroundColor(Color("BioColor"))
                .frame(width: 340, height: 130, alignment: .center)
                .padding(.bottom, 75)
//                .overlay(
//                    ScrollView(.horizontal) {
//                        LazyHStack {
//                            ForEach(userViewModel.currentUser.interests, id: \.self) {interests in
//                                Text("\(interests), ".capitalized)
//                                    .foregroundColor(.white)
//                                    .padding(.bottom, 75)
//                                    .font(Font.custom("San Francisco", size: 20))
//                                    .padding(.leading, 10)
//                            }
//                        }
//                    }
//                )
                .overlay(
                    //BIO Text
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .foregroundColor(Color("SmallBioImage"))
                        .frame(width: 100, height: 30, alignment: .center)
                        .padding(.bottom, 150)
                        .padding(.trailing, 230)
                        .overlay(
                            Text("Interests")
                                .foregroundColor(.white)
                                .padding(.bottom, 150)
                                .padding(.trailing, 230)
                        )
                )
            VStack(alignment: .leading) {
                Text("My Courses")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .padding(.trailing, 190)
                    .padding(.top, 100)
                    .foregroundColor(.black)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    HStack() {
                    ForEach(courseViewModel.courses, id: \.self) { course in
                        NavigationLink(destination: Text("Course View")) {
                        CourseGroupView(courseViewModel: CourseViewModel(), courseItem: course)
                        }
                        
                    }
                    }
                    //.cornerRadius(15)
                    
                    //.frame(height: 200)
                    
                }
                
                }
                
            }
            .padding(.leading, 30)
            .padding(.top, 300)
            
            
        }
        .onAppear() {
            //networkViewModel.readNetworkItems()
            //let uid = Auth.auth().currentUser?.uid
            //self.networkViewModel.getAllUsersInNetwork(currentUserID: uid!)
            //ForEach(self.networkViewModel.getAllUsersInNetwork(currentUserID: uid!), id: \.self) {
                
            //}
        }
        .foregroundColor(.white)
        .sheet(isPresented: $shouldShowImagePicker, content: {
                ImagePicker(image: $image)
                    
            
        })
    }

    
}

struct ClickedUserProfileButtons: View {
    
    @ObservedObject var networkViewModel: NetworkViewModel
    let uid = Auth.auth().currentUser?.uid
    @State var isChatButtonPressed = false
    @State var userItem: FetchedUserModel
    @State var isFollowing: Bool = false
    @Binding var following: Int

    //@ObservedObject var ChatLogViewModel: ChatLogViewModel
    var body: some View {
        HStack {
            
            NavigationLink(
                destination: MainMessagesView(),
                isActive: $isChatButtonPressed,
                label: {
                    Button(action: {
                        isChatButtonPressed.toggle()
                        //MainMessagesView()
                        }, label: {
                            Text("Chat")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .stroke(Color.gray, lineWidth: 1)
                                        .frame(width: 150, height: 45)

                                )


                        })
                })
                

            
            Spacer()
                .frame(width: 80)

            Button(action: {
                if isFollowing == false {
                    self.networkViewModel.updateUserNetwork2(currentUserID: uid!, withUser: userItem)
                }
                else {
                    self.networkViewModel.deleteUserNetwork2(withUser: userItem)
                }
                isFollowing.toggle()
                following += 1
                }, label: {
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .fill(Color("SettingsButtonColor"))
                        .frame(width: 150, height: 45)
                        .overlay(
                            Text(isFollowing ? "Unfollow": "Follow")
                                .font(.system(size: 15))
                        )


                })

                //.padding(.trailing, 150)

        }
        .padding(.bottom, 385)
        .padding(.leading, 50)
    }

}


struct ClickedUserImageView: View {
    
    @Binding var shouldShowImagePicker: Bool
    @Binding var image: UIImage?
    @Binding var isImageSelected: Bool
    
    
    @State var userItem: FetchedUserModel
    
    @StateObject var currentUser: UserViewModel = UserViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        //Adding Profile Picture
        VStack {
                    VStack {
                        
                        if (!userItem.profileImageUrl.isEmpty) {
                            WebImage(url: URL(string:
                                                userItem.profileImageUrl))
                                                .resizable()
                                                .frame(width: 130, height: 130)
                                                .cornerRadius(20)
                                                .scaledToFill()
                        }
                        else {
                            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                .foregroundColor(Color("ProfileColor"))
                                .frame(width: 130, height: 130, alignment: .leading)
                                .overlay(
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .font(.system(size: 44))
                                        .foregroundColor(.black)
                                )}
                        }
                }
                .padding(.bottom, 610)
                .padding(.trailing, 200)
                
        }
}

struct ClickedUserNameView: View {
    @StateObject var currentUser: UserViewModel = UserViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @State var userItem: FetchedUserModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(userItem.fName)" + " " + "\(userItem.lName)" )
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.leading, 35)
            
                
                
            Text("Class of " + "\(userItem.classYear)")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .padding(.leading, 35)
        }
        .padding(.bottom, 680)
        .padding(.leading, 100)
    }
}

struct ClickedUserFollowersView: View {
    @Binding var following: Int
    var body: some View{
        VStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundColor(Color("ProfileColor"))
                .frame(width: 175, height: 60, alignment: .leading)
            
        }
        .padding(.bottom, 540)
        .padding(.leading, 130)
        .overlay(
            HStack {
                VStack {
                    Text("Followers")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    //Spacer()
                    Text("34")
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                    
                }
                Spacer()
                    .frame(width: 25)
                VStack {
                    Text("Following")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    //Spacer()
                    Text("\(following)")
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                }
            }
            .padding(.leading, 130)
            .padding(.bottom, 540)
            
        )
        
    }
}

