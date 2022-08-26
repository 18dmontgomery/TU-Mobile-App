//
//  ProfileView.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/20/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @ObservedObject var courseViewModel: CourseViewModel
    @ObservedObject var networkViewModel: NetworkViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var isCanceledClicked = false
    @State var isImageSelected = false
    @State var chatUser: ChatUser?
    
    
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
                        .overlay(ImageView(shouldShowImagePicker: $shouldShowImagePicker, image: $image, isImageSelected: $isImageSelected))
                        .overlay(nameView())
                        .overlay(FollowersView())
                        .overlay(ProfileButtons())
                        
                }
                
                
           
            }

            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    HStack() {
                        ForEach(userViewModel.currentUser.interests, id: \.self) {interests in
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).foregroundColor(.blue)
                                    .frame(width: 100, height: 100, alignment: .center)
                                HStack {
                                    Text("\(interests)".capitalized)
                                }

                            }
                            //.padding(.trailing, 190)
                            .padding(.bottom, 50)

                        }
                        
                    }
                    
                }
                
            }
    }
        .padding(.leading, 30)
        .padding(.trailing, 30)

        .padding(.bottom, 50)
            

            .overlay(Interests())
            //BIO Rounded Rectangle
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .fill(
                    LinearGradient(gradient: Gradient(colors: [Color("StartBioColor"), Color("EndBioColor")]), startPoint: .leading, endPoint: .trailing)
                )
                //.foregroundColor(Color("BioColor"))
                .frame(width: 340, height: 130, alignment: .center)
                
                .overlay(
                    //BIO Text
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .foregroundColor(Color("SmallBioImage"))
                        .frame(width: 100, height: 30, alignment: .topLeading)
                        
                        .overlay(
                            Text("About Me")
                                .foregroundColor(.white)
                                
                        )
                        
                        .padding(.trailing, 230)
                        .padding(.bottom, 90)
                )
                .padding(.bottom, 20)

            VStack(alignment: .leading) {
                Text("My Courses")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .padding(.trailing, 190)
                    .padding(.top, 120)
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
        .foregroundColor(.white)
        .sheet(isPresented: $shouldShowImagePicker, content: {
                ImagePicker(image: $image)        })
    }
    
}
struct Interests: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View{
        
        HStack{
            ForEach(userViewModel.currentUser.interests, id: \.self) {interests in
                       RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                            .fill(
                               LinearGradient(gradient: Gradient(colors: [Color("StartBioColor"), Color("EndBioColor")]), startPoint: .leading, endPoint: .trailing)
                            )
                            .scaledToFit()
                            .frame(width: 70, height: 30, alignment: .center)
                            
                        //.padding(.vertical, 75)
                            .font(Font.custom("San Francisco", size: 10))
                            .overlay(Text("\(interests)".capitalized)
                                    .multilineTextAlignment(.center)
                                        
                            
                )
            }
        }
        .padding(.bottom, 225)
    }
}

struct ProfileButtons: View {
    @State var isChatButtonPressed = false
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
                //self.persistImageToStorage()
                }, label: {
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .fill(Color("SettingsButtonColor"))
                        .frame(width: 150, height: 45)
                        .overlay(
                            Text("Settings")
                                .font(.system(size: 15))
                        )


                })

                //.padding(.trailing, 150)

        }
        .padding(.bottom, 385)
        .padding(.leading, 50)
    }

}


struct ImageView: View {
    
    @Binding var shouldShowImagePicker: Bool
    @Binding var image: UIImage?
    @Binding var isImageSelected: Bool
    
    @StateObject var currentUser: UserViewModel = UserViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        //Adding Profile Picture
        VStack {
            Button(action: {
                shouldShowImagePicker.toggle()
                isImageSelected = true
                self.persistImageToStorage()
                }, label: {
                    VStack {
                        
                        
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .cornerRadius(20)
                                .scaledToFill()
                            //self.persistImageToStorage()
                        }
                        else if (!userViewModel.currentUser.profileImageUrl.isEmpty) {
                            WebImage(url: URL(string:
                                                userViewModel.currentUser.profileImageUrl))
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
                    })
                }
                .padding(.bottom, 610)
                .padding(.trailing, 200)
                
        }
    
    public func persistImageToStorage() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let ref = FirebaseManager.shared.storage.reference(withPath: uid)
            guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    let _  = "Failed to push image to Storage: \(err)"
                    return
                }

                ref.downloadURL { url, err in
                    if let err = err {
                        let _ = "Failed to retrieve downloadURL: \(err)"
                        return
                    }

                    let _ = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                    print(url?.absoluteString)

                    guard let url = url else {return}
                    self.storeUserInformation(imageProfileUrl: url)
                }
            }
        }

    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).updateData(userData) { err in
                if let err = err {
                    print(err)
                    let _ = print("\(err)")
                    return
                }

                print("Success")
            }
    }
}

struct nameView: View {
    @StateObject var currentUser: UserViewModel = UserViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(userViewModel.currentUser.fName)" + " " + "\(userViewModel.currentUser.lName)" )
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.leading, 35)
            
                
                
            Text("Class of " + "\(userViewModel.currentUser.classYear)")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .padding(.leading, 35)
        }
        .padding(.bottom, 680)
        .padding(.leading, 100)
    }
}

struct FollowersView: View {
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
                    Text("38")
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                }
            }
            .padding(.leading, 130)
            .padding(.bottom, 540)
            
        )
        
    }
}
