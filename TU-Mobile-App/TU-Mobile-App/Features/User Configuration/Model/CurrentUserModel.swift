//
//  CurrentUserModel.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/28/21.
//

import Combine
import Foundation
import SwiftUI

struct CurrentUserModel: Identifiable, Hashable, Codable {

    var id: String = UUID().uuidString
    var fName: String
    var lName: String
    var gender: String
    var classYear: String
    var major: String
    var minor: String
    var profileImageUrl: String
    var network: [FetchedUserModel]
    var interests: [String]


    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case fName = "fistName"
        case lName = "lastName"
        case gender
        case classYear = "class"
        case major
        case minor
        case profileImageUrl
        case network
        case interests
    }
}
