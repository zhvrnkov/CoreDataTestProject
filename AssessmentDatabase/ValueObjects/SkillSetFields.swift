//
//  SkillSetValueFields.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

public protocol SkillSetFields {
    var sid: Int { get set }
    
    var rubric: RubricFields { get set }
    var microTasks: [Microtask] { get set }
}
