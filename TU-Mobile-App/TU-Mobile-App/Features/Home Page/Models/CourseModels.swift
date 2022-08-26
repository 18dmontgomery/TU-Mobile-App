//
//  CourseModels.swift
//  TUMobileApp
//
//  Created by Boone on 9/29/21.
//
import Combine
import Foundation

struct Course: Hashable {
  let name: String
  let description: String
  let taughtBy: String
  let thumbnail: String
}
