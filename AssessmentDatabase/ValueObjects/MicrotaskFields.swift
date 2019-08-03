//
//  MicrotaskValueFields.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

public protocol MicrotaskFields {
    var sid: Int { get set }
    
    var skillSet: SkillSetFields { get set }
    var studentMicroTaskGrades: [StudentMicrotaskGrade] { get set }
}
