//
//  ProductService.swift
//  ShopifyW20
//
//  Created by Dema Abu Adas on 2019-09-22.
//  Copyright © 2019 Dema Abu Adas. All rights reserved.
//

import Foundation
import Moya

enum ProductService {
    case getProducts
}

extension ProductService: TargetType {
    var baseURL: URL {
        switch self {
        case .getProducts:
              return URL(string: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")!
        }

    }
    
    var path: String {
        return("")
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        var something: Data
        something = try! JSONEncoder().encode("uh")
        return something
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
