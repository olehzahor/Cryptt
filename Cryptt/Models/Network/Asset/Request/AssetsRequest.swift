//
//  AssetsRequest.swift
//  Cryptt
//
//  Created by Oleh Zahoriansky on 15.02.2022.
//

import Foundation

struct AssetsRequest: Encodable {
    let search: String?
    let limit: Int?
    let offset: Int?
}
