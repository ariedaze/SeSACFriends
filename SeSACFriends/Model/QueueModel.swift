//
//  QueueModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/08.
//

import Foundation

struct Queue: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}
