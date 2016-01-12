//
//  Actor+CoreDataProperties.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 12.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Actor {

    @NSManaged var name: String?
    @NSManaged var uuid: String?
    @NSManaged var room: String?
    @NSManaged var dimmable: NSNumber?
    @NSManaged var isScene: NSNumber?
    @NSManaged var isFavorite: NSNumber?

}
