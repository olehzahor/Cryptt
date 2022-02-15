//
//  CollectionResponse.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import Foundation

struct CollectionResponse<T: Codable>: Codable {
    let data: [T]
}
