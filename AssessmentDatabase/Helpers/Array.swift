//
//  Array.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 8/12/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

extension Array where Element: Sidable {
    var sids: [Int64] {
        return map { $0.sid }
    }
}
