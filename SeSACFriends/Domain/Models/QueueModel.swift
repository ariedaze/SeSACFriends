//
//  QueueModel.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/08.
//

import Foundation

struct QueueResponse: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
    
    static let defaultValue = QueueResponse(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: [])
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}

struct QueueState: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
}
