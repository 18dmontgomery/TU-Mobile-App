//
//  FetchedUserModel.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/13/21.
//
import Combine
import Foundation
import SwiftUI

struct FetchedUserModel: Identifiable, Hashable, Codable {

    var id: String = UUID().uuidString
    var fName: String
    var lName: String
    var gender: String
    var classYear: String
    var major: String
    var minor: String
    var profileImageUrl: String


    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case fName = "fistName"
        case lName = "lastName"
        case gender
        case classYear = "class"
        case major
        case minor
        case profileImageUrl = "profileImageUrl"
    }
}
