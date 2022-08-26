//
//  File.swift
//  TUMobileApp
//
//  Created by Boone on 9/29/21.
//
import Combine
import SwiftUI
import Foundation

class CourseViewModel: ObservableObject {
  
  @Published var courses: [Course]
  
  init() {
    
    //this should be in a services file probably
    //temporary storage for rn
    
    courses = [Course(name: "Math", description: "Dummy Description1", taughtBy: "Professor 1", thumbnail: "download-1.jpg"),
               Course(name: "English", description: "Dummy Description2", taughtBy: "Professor 2", thumbnail: "download.jpg"),
               Course(name: "Physics", description: "Dummy Description3", taughtBy: "Professor 3", thumbnail: "road-1072821__340.jpg"),
               Course(name: "Biology", description: "Dummy Description4", taughtBy: "Professor 4", thumbnail: "stock-photo-142984111.jpg"),
               Course(name: "Databases", description: "Dummy Description5", taughtBy: "Professor 5", thumbnail: "waterfall-1140x760.jpeg")]
    
  }

}
