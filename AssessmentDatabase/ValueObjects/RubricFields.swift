//
//  RubricsValueFields.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

public protocol RubricFields {
    var sid: Int { get set }
    var skillSets: [SkillSetFields] { get set }
}
