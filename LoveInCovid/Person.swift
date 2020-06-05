//
//  Person.swift
//  LoveInCovid
//
//  Created by Parrot on 2020-06-02.
//  Copyright © 2020 Parrot. All rights reserved.
//

import Foundation
class Person {
    var name:String?
    var age:Int?
    var photo:String?
    
    init(name:String?, age:Int?, photo:String?) {
        self.name = name
        self.age = age
        self.photo = photo
    }
}
