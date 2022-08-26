//
//  UserModel.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/9/21.
//

import Foundation

struct UserModel: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var classes: String
    var fname: String
    var gender: String
    var lname: String
    var major: String
    var profileImageUrl: String
}
