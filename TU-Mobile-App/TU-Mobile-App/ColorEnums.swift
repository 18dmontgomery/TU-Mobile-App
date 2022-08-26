//
//  ColorEnums.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/12/21.
//

import Foundation
import SwiftUI

enum CustomColor: String {
  case TUBlue
  case TUGold
}

extension Color {
  static func getCustomColor(_ customColor: CustomColor) -> Self {
    return Color(customColor.rawValue)
  }
}
