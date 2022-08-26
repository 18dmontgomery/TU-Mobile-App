//
//  TabBar.swift
//  TU-Mobile-App
//
//  Created by Boone on 10/21/21.
//
import Foundation
import SwiftUI

struct TabBar: View {
    
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    @StateObject var currentUser = UserViewModel()
    
    @State var isNavigationBarHidden: Bool = true
  
  var body: some View {
    
    TabView {
      
        HomeView(courseViewModel: CourseViewModel(), networkViewModel: NetworkViewModel(), loginViewModel: LoginViewModel(), isNavigationBarHidden: $isNavigationBarHidden)
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
      
        MapView()
            .tabItem {
                Label("Map", systemImage: "map")
            }
      
      Text("Calendar")
        .tabItem {
          Label("Calendar", systemImage: "calendar")
        }
      
        ExploreView(courseViewModel: CourseViewModel(), networkViewModel: NetworkViewModel(), loginViewModel: LoginViewModel())
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass")
            }
      
    ProfileView(courseViewModel: CourseViewModel(), networkViewModel: NetworkViewModel(), loginViewModel: LoginViewModel())
        .tabItem {
          Label("Profile", systemImage: "person.crop.circle.fill")
        }
    }
    .accentColor(.black)
    .environmentObject(currentUser)
  }
  
}
