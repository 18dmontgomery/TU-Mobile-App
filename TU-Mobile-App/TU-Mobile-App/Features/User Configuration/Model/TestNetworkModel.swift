//
//  TestNetworkModel.swift
//  TU-Mobile-App
//
//  Created by Boone on 11/27/21.
//

import Combine
import Foundation
import SwiftUI

struct TestNetworkModel: Hashable, Codable {

    var network: [String]?

    enum CodingKeys: String, CodingKey {
        case network
    }
}
