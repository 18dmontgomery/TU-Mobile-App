//
//  LoginModels.swift
//  TU-Mobile-App
//
//  Created by Hunter Boone on 11/9/21.
//
import Combine
import Foundation
import SwiftUI

struct LoginModels: Codable {
    
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let gender: String
    let isLoginMode: Bool
    
}
