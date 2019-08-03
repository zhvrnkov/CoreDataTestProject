//
//  InstructorValueFields.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

public protocol InstructorFields {
    var sid: Int { get set }
    
    var assessments: [AssessmentFields] { get set }
    var students: [StudentFields] { get set }
}
