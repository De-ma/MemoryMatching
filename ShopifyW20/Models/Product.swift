//
//  Product.swift
//  ShopifyW20
//
//  Created by Dema Abu Adas on 2019-09-22.
//  Copyright © 2019 Dema Abu Adas. All rights reserved.
//

import Foundation

struct Product: Decodable {
    var image: Image
}

extension Product {
    enum CodingKeys: String, CodingKey {
        case image
    }
}
