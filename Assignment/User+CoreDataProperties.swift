//
//  User+CoreDataProperties.swift
//  
//
//  Created by Vivek on 03/06/18.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var gander: String?
    @NSManaged public var lastName: String?
    @NSManaged public var mobileNumber: String?
    @NSManaged public var password: String?
    

}
