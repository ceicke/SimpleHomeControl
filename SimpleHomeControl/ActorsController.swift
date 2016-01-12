//
//  ActorsController.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 12.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//

import UIKit
import CoreData

class ActorsController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var actors = [NSManagedObject]()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    override func viewDidLoad() {
        managedContext = appDelegate.managedObjectContext
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("seedData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    func seedData() {
        
        let entity =  NSEntityDescription.entityForName("Actor", inManagedObjectContext:managedContext)
        let actor = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        actor.setValue("Deckenleuchte", forKey: "name")
        actor.setValue("Schlafzimmer", forKey: "room")
        actor.setValue("8283429384", forKey: "uuid")
        actor.setValue(0, forKey: "dimmable")
        actor.setValue(0, forKey: "isScene")
        actor.setValue(0, forKey: "isFavorite")
        
        do {
            try managedContext.save()
            actors.append(actor)
        } catch let error as NSError  {
            NSLog("Could not save \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
        refreshControl!.endRefreshing()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showActor" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                (segue.destinationViewController as! ActorDetailsController).actor = actors[indexPath.row] as? Actor
                (segue.destinationViewController as! ActorDetailsController).managedObjectContext = appDelegate.managedObjectContext
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName: "Actor")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            actors = results as! [NSManagedObject]
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return actors.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ActorCell
            let actor = actors[indexPath.row]
            cell.configure(actor.valueForKey("name")!.description)
            return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

}