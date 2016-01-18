//
//  Actor.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 14.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//

import Foundation
import CoreData


class Actor: NSManagedObject {

    func used() {
        self.useCount = Int(self.useCount!) + 1
        save()
    }
    
    func save() {
        do {
            try self.managedObjectContext!.save()
        }
        catch let error as NSError {
            NSLog("Error saving: %@", error)
        }
    }

}
