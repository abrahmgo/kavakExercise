//
//  gnome.swift
//  kavakExercise
//
//  Created by Andrés Abraham Bonilla Gómez on 12/2/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import Foundation

struct gnome: Codable {
    var id : Int
    var name : String
    var thumbnail : String
    var age : Int
    var weight : Double
    var height : Double
    var hairColor : String
    var professions : [String]
    var friends : [String]
}
