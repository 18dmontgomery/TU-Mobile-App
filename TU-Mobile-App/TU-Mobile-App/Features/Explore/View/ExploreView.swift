//
//  ExploreView.swift
//  TUMobileApp
//
//  Created by Boone on 11/14/21.
//
import Combine
import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct ExploreView: View {

    @ObservedObject var courseViewModel: CourseViewModel
    @ObservedObject var networkViewModel: NetworkViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    let uid = Auth.auth().currentUser?.uid

    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {

            VStack(alignment: .leading) {

                Text("Users you might know")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .padding(.leading, 30)
                .padding(.top, 20)
                // Network Requests
                .onAppear() {
                    let _ = print("Invoking on appear...")

                    // Fetching users by major..
                    // "Matching Algorithm"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.networkViewModel.getAllUsersByMajor(userMajor: userViewModel.currentUser.major)
                    }
                }

                //ScrollView of Matches
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(networkViewModel.users, id: \.self) { user in
                                let _ = print(user)
                                //Will link to "Profile View" instead of "TestProfileView" with respective information
                                NavigationLink(destination: ClickedProfileView(courseViewModel: CourseViewModel(), networkViewModel: NetworkViewModel(), loginViewModel: LoginViewModel(), userItem: user)) {
                                    GroupView(networkViewModel: NetworkViewModel(), networkItem: user)
                                }
                            }
                        }
                        .padding(.leading, 30)
                    }

                }

            }

        }
        .navigationTitle("Explore")

  }
}

// Displays tiles for each user in the network
struct GroupView: View {

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

