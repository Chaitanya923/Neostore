//
//  Response.swift
//  NeoSTORE
//
//  Created by Neosoft on 30/12/21.
//

import Foundation

struct Response<T : Codable>: Codable {
    let status: Int
    let message: String?
    let data: [T]
    let userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, message, data
        case userMsg = "user_msg"
    }
}


struct ResponseSingleData<T : Codable>: Codable {
    let status: Int
    let message: String?
    let data: T
    let userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, message, data
        case userMsg = "user_msg"
    }
}

