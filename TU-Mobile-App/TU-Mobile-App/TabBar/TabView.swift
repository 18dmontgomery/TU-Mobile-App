//
//  TabView.swift
//  TU-Mobile-App
//
//  Created by Boone on 10/21/21.
//
import Foundation
import SwiftUI

struct TabBar: View {
  
  var body: some View {
    
    TabView {
      
      HomeView(courseViewModel: CourseViewModel(), networkViewModel: NetworkViewModel())
        .tabItem {
          Label("Menu", systemImage: "list.dash")
        }
      
    }
    
  }
  
}
