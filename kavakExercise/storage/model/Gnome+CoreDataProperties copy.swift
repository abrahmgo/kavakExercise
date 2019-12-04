//
//  Gnome+CoreDataProperties.swift
//  
//
//  Created by Andrés Bonilla on 12/4/19.
//
//

import Foundation
import CoreData


extension Gnome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gnome> {
        return NSFetchRequest<Gnome>(entityName: "Gnome")
    }

    @NSManaged public var id: Int16
    @NSManaged public var thumbnail: String?
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var weight: Double
    @NSManaged public var height: Double
    @NSManaged public var hairColor: String?
    @NSManaged public var professions: NSObject?
    @NSManaged public var friends: NSObject?

}
