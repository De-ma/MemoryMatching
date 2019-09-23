//
//  Product.swift
//  ShopifyW20
//
//  Created by Dema Abu Adas on 2019-09-22.
//  Copyright © 2019 Dema Abu Adas. All rights reserved.
//

import Foundation

struct Product: Decodable {
    var id: Int
    var title: String
    var body_html: String
    var vendor: String
    var product_type: String
    var created_at: String
    var handle: String
    var updated_at: String
    var published_at: String
    var template_suffix: String?
    var tags: String
    var published_scope: String
    var admin_graphql_api_id: String
    var variants: [Variant]
    var options: [Option]
    var images: [Image]
    var image: Image
    
}

extension Product {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body_html
        case vendor
        case product_type
        case created_at
        case handle
        case updated_at
        case published_at
        case template_suffix
        case tags
        case published_scope
        case admin_graphql_api_id
        case variants
        case options
        case images
        case image
    }
}
