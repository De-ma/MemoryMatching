//
//  Image.swift
//  ShopifyW20
//
//  Created by Dema Abu Adas on 2019-09-22.
//  Copyright © 2019 Dema Abu Adas. All rights reserved.
//

import Foundation

struct Image: Decodable {
    var id: Int
    var product_id: Int
    var position: Int
    var created_at: String
    var updated_at: String
    var alt: String?
    var width: Int
    var height: Int
    var src: String
    var variant_ids: [String]?
    var admin_graphql_api_id: String
}

extension Image {
    enum CodingKeys: String, CodingKey {
        case id
        case product_id
        case position
        case created_at
        case updated_at
        case alt
        case width
        case height
        case src
        case variant_ids
        case admin_graphql_api_id
    }
}
