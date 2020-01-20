//
//  Image.swift
//  ShopifyW20
//
//  Created by Dema Abu Adas on 2019-09-22.
//  Copyright © 2019 Dema Abu Adas. All rights reserved.
//

import Foundation

struct Image: Decodable {
    var src: String
}

extension Image {
    enum CodingKeys: String, CodingKey {
        case src
    }
}
