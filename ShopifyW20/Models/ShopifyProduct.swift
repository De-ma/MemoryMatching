//
//  ShopifyProduct.swift
//  ShopifyW20
//
//  Created by Dema Abu Adas on 2019-09-22.
//  Copyright © 2019 Dema Abu Adas. All rights reserved.
//

import Foundation

struct ShopifyProduct: Decodable {
    var products: [Product]
}

extension ShopifyProduct {
    enum CodingKeys: String, CodingKey {
        case products
    }
}

