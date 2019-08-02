//
//  StudentMicrotaskGradeValueFields.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

public protocol StudentMicrotaskGradeFields {
    var sid: Int { get set }
    
    var assessment: AssessmentFields { get set }
    var grade: GradeFields { get set }
    #warning("")
//    var microTask: MicrotaskFields { get set }
    var student: StudentFields { get set }
}
