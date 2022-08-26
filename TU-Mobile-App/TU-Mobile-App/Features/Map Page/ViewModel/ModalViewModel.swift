//
//  ModalVIewModel.swift
//  TU-Mobile-App
//
//  Created by David Montgomery on 11/8/21.
//

import SwiftUI
import Foundation

class ModalViewModel: ObservableObject {
  
    
    @Published var names: [String]
    @Published var areNamesClicked: Bool
    @Published var areNamesSaved: Bool
  
  init() {
    
    names = []
    areNamesClicked = false
    areNamesSaved = false
  }
    
    func add(name: String) {

        var localCheck: Bool
        localCheck = checkFunc(name: name)
        if localCheck == true {
            areNamesClicked = true
            names.append(name)
            //print(name)
            print(names)
        }
        else {
            if let index = names.firstIndex(of: name) {
                names.remove(at: index)
            }
            if(names.isEmpty) {
                areNamesClicked = false
            }
            else  {
                areNamesClicked = true
            }
            print(names)
            
        }
    }
    
//    func remove(name: String) {
//
//        var localCheck: Bool
//        localCheck = checkFunc(name: name)
//        if localCheck == true {
//            if let index = names.firstIndex(of: name) {
//                names.remove(at: index)
//            }
//            if(names.isEmpty) {
//                areNamesClicked = false
//            }
//            else  {
//                areNamesClicked = true
//            }
//            print(names)
//        }
//
//    }


    func checkFunc(name: String)-> Bool {
        var check: Bool
        if names.isEmpty {
            areNamesClicked = false
            check = true
            return check
        }
        else if names.contains(name) {
            areNamesClicked = true
            check = false
            return check
        }
        else {
            areNamesClicked = true
            check = true
            return check
        }

    }
    
    func containsToo(name: String) -> Bool {
        if (names.contains(name)) {
            areNamesSaved = true
            return areNamesSaved
        }
        else {
            areNamesSaved = false
            return areNamesSaved
        }
    }
}

