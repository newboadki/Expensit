//
//  Tag+CoreDataProperties.swift
//  
//
//  Created by Borja Arias Drake on 12/07/2020.
//
//

import Foundation
import UIKit
import CoreData


extension Tag {

    @nonobjc public class func tagFetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var color: UIColor
    @NSManaged public var iconImageName: String
    @NSManaged public var name: String

}
