//
//  Test.swift
//  TUMobileApp
//
//  Created by Boone on 9/29/21.
//
import Combine
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {

    @ObservedObject var courseViewModel: CourseViewModel
    @ObservedObject var networkViewModel: NetworkViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var selectedUser: TestNetworkModel? = nil
    @State private var didAppearTimeInterval: TimeInterval = 0
    

    @Binding var isNavigationBarHidden: Bool

    let uid = Auth.auth().currentUser?.uid
    

    var body: some View {

    NavigationView {

        ScrollView(.vertical, showsIndicators: false) {

            VStack(alignment: .leading) {

                Text("Hello")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding(.leading, 20)

                Text("\(userViewModel.currentUser.fName),")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding(.leading, 20)
                //.padding(.top, 5)
                .padding(.bottom, 10)

                Text("Upcoming Tasks")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .padding(.leading, 30)
                .padding(.top, 15)

                Text("No Tasks Today.")
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .fontWeight(.bold)
                .padding(.leading, 40)
                .padding(.top, 10)

                Text("Around the Network")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .padding(.leading, 30)
                .padding(.top, 20)

                //"Network"
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(networkViewModel.users, id: \.self) { user in
                                let _ = print(user)
                                //Will link to "Profile View" instead of "TestProfileView" with respective information
                                NavigationLink(destination: ClickedProfileView(courseViewModel: CourseViewModel(), networkViewModel: NetworkViewModel(), loginViewModel: LoginViewModel(), userItem: user)) {
                                    GroupView2(networkViewModel: NetworkViewModel(), networkItem: user)
                                }
                            }
                        }
                        .padding(.leading, 30)
                    }

                }


                Text("My Courses")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .padding(.leading, 30)
                .padding(.top, 15)

                //"My Courses"
                ScrollView(.horizontal, showsIndicators: false) {

                    VStack(alignment: .leading) {
                        HStack() {
                            ForEach(courseViewModel.courses, id: \.self) { course in
                                NavigationLink(destination: Text("Course View")) {
                                    CourseGroupView(courseViewModel: CourseViewModel(), courseItem: course)
                                }
                            }
                        }
                        .padding(.leading, 30)
                    }

                }

                //Log-out Button
                Button(action: {

                    loginViewModel.signOut()

                }) {

                    Text("Log-out")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color(.blue))
                .cornerRadius(10)
                .padding(.top, 25)

            }

        }
        .onAppear() {
            let _ = print("Attempting to fetch current user's data...")
            self.userViewModel.getCurrentUser(userID: uid!)

            //Doesn't Fetch User Network Yet
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.networkViewModel.getAllUsersInNetwork(currentUserID: uid!)
            }
        }

        //MARK: TODO - Doesn't work atm because of nested navigation views
        .toolbar {

            ToolbarItemGroup(placement: .navigationBarTrailing) {
              NavigationLink(destination: Text("hello")) {
                Image(systemName: "bell")
              }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
              NavigationLink(destination: MainMessagesView()) {
                Image(systemName: "message")
                  .resizable()
                  .frame(width: 100, height: 100)
              }
            }

        }
// Navigation View
    }
    
    .accentColor(Color(.black))
    .navigationBarHidden(true)

  }
    
    private func onAppear() {
        if Date().timeIntervalSince1970 - didAppearTimeInterval > 0.5 {
            ///////////////////////////////////////
            // Gets called only once in 0.5 seconds <-----------
            ///////////////////////////////////////
        }
        didAppearTimeInterval = Date().timeIntervalSince1970
    }
    
    
}



struct GroupView2: View {

  @ObservedObject var networkViewModel: NetworkViewModel

  let networkItem: FetchedUserModel

  var body: some View {

    ZStack {

        RoundedRectangle(cornerRadius: 10)
            .fill(Color.getCustomColor(.TUBlue))

        VStack(alignment: .leading) {
            Spacer()

            Text(networkItem.fName)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(networkItem.major)
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .frame(width: 110, height: 160)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .padding(.trailing, 5)

    }

  }

}

//struct NetworkGroupView: View {
//
//  @ObservedObject var networkViewModel: NetworkViewModel
//
////  let networkItem: FetchedUserModel
//
//    var body: some View {
//
//      ZStack {
//
//          RoundedRectangle(cornerRadius: 10)
//              .fill(Color.getCustomColor(.TUBlue))
//
//          VStack(alignment: .leading) {
//              Spacer()
//
//              Text("test")
//                  .font(.system(size: 18))
//                  .fontWeight(.bold)
//                  .foregroundColor(.white)
//
//              Text("teste")
//                  .font(.system(size: 14))
//                  .fontWeight(.semibold)
//                  .foregroundColor(.white)
//          }
//          .frame(width: 110, height: 160)
//          .padding(.top, 10)
//          .padding(.bottom, 10)
//          .padding(.trailing, 5)
//
//      }
//
//    }
//
//}

struct CourseGroupView: View {

  @ObservedObject var courseViewModel: CourseViewModel
  @State private var imageURL = URL(string: "")

  let courseItem: Course

  var body: some View {

    VStack(alignment: .leading) {

        WebImage(url: imageURL)
                    .resizable()
                    .frame(width: 160, height: 160)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .padding(.trailing, 10)

      Text(courseItem.name)
        .fontWeight(.bold)
        .foregroundColor(.gray)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
        .frame(width: 160, height: 50, alignment: .topLeading)
        .padding(.bottom, 10)

    }
    .padding(.trailing, 10)
    .onAppear(perform: {
        loadImageFromFirebase()
    })

  }

    func loadImageFromFirebase() {
        let storage = Storage.storage().reference(withPath: "ClassStockImages/\(courseItem.thumbnail)")
         storage.downloadURL { (url, error) in
             if error != nil {
                 print((error?.localizedDescription)!)
                 return
         }
            //print("Download success”)
         self.imageURL = url!
     }
    }
}
