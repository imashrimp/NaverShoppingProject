//
//  NaverShoppingModel.swift
//  NaverShoppingList_2ndRecap
//
//  Created by 권현석 on 2023/09/07.
//

import Foundation

struct NaverShopping: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let image: String
    let lprice, mallName, productID: String

    enum CodingKeys: String, CodingKey {
        case title, image, lprice, mallName
        case productID = "productId"
    }
}
