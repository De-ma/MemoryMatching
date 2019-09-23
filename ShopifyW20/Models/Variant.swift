//
//  Variant.swift
//  ShopifyW20
//
//  Created by Dema Abu Adas on 2019-09-22.
//  Copyright © 2019 Dema Abu Adas. All rights reserved.
//

import Foundation

struct Variant: Decodable {
    var id: Int
    var product_id: Int
    var title: String
    var price: String
    var sku: String
    var position: Int
    var inventory_policy: String
    var compare_at_price: String?
    var fulfillment_service: String
    var inventory_management: String?
    var option1: String?
    var option2: String?
    var option3: String?
    var created_at: String
    var updated_at: String
    var taxable: Bool
    var barcode: String?
    var grams: Int
    var image_id: Int?
    var weight: Double
    var weight_unit: String
    var inventory_item_id: Int
    var inventory_quantity: Int
    var old_inventory_quantity: Int
    var requires_shipping: Bool
    var admin_graphql_api_id: String
}


extension Variant {
    enum CodingKeys: String, CodingKey {
        case id
        case product_id
        case title
        case price
        case sku
        case position
        case inventory_policy
        case compare_at_price
        case fulfillment_service
        case inventory_management
        case option1
        case option2
        case option3
        case created_at
        case updated_at
        case taxable
        case barcode
        case grams
        case image_id
        case weight
        case weight_unit
        case inventory_item_id
        case inventory_quantity
        case old_inventory_quantity
        case requires_shipping
        case admin_graphql_api_id
    }
}
