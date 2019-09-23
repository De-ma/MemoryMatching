//
//  Option.swift
//  ShopifyW20
//
//  Created by Dema Abu Adas on 2019-09-22.
//  Copyright © 2019 Dema Abu Adas. All rights reserved.
//

import Foundation

struct Option: Decodable {
    var id: Int
    var product_id: Int
    var name: String
    var position: Int
    var values: [String]
}

extension Option {
    enum CodingKeys: String, CodingKey {
        case id
        case product_id
        case name
        case position
        case values
    }
}
