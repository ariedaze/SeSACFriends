//
//  Double+Extension.swift
//  SeSACFriends
//
//  Created by Ahyeonway on 2022/02/13.
//

import Foundation

extension Double {
    // (POST, /queue/onqueue) 에 대한 요청 바디 정보
    // 위도에 +90 후 소수점 제거한 후 앞 5자리
    var lat5: Int {
        let latPositive = Int((self+90)*100000)
        return latPositive/Int(pow(10.0, Double(latPositive.description.count-5)))
    }
    // 경도에 +90 후 소수점 제거한 후 앞 5자리
    var long5: Int {
        let longPositive = Int((self+180)*100000)
        return longPositive/Int(pow(10.0, Double(longPositive.description.count-5)))
    }
}
