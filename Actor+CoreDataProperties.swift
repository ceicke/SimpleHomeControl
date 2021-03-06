//
//  Actor+CoreDataProperties.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 14.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Actor {

    @NSManaged var isDimmable: NSNumber?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var name: String?
    @NSManaged var room_uuid: String?
    @NSManaged var scene: String?
    @NSManaged var uuid: String?
    @NSManaged var useCount: NSNumber?

}
