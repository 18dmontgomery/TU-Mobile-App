//
//  UserModel.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/13/21.
//
import Combine
import Foundation
import SwiftUI

struct UserModels: Identifiable, Hashable {

    var id: String = UUID().uuidString
    var fName = ""
    var lName = ""
    var gender = ""
    var classYear = ""
    var major = ""
    var minor = ""


    enum CodingKeys: String, CodingKey {
        case id = "UUID"
        case fName = "fistName"
        case lName = "lastName"
        case gender
        case classYear = "class"
        case major
        case minor
    }
}
