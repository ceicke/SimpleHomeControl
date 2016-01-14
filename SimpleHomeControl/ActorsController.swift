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
    var loxone = Loxone()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    override func viewDidLoad() {
        managedContext = appDelegate.managedObjectContext
        loxone.managedContext = appDelegate.managedObjectContext
        
        let refreshControl = UIRefreshControl()
        if(loxone.settingsEntered()) {
            refreshControl.addTarget(self, action: Selector("loadData"), forControlEvents: UIControlEvents.ValueChanged)
        } else {
            refreshControl.addTarget(self, action: Selector("enterData"), forControlEvents: UIControlEvents.ValueChanged)
        }
        self.refreshControl = refreshControl
    }
    
    func enterData() {
        UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
        refreshControl!.endRefreshing()
    }
    
    func loadData() {
        loxone.getRooms { (isDone) -> Void in
            if (isDone) {
                self.loxone.getControls { (isDone) -> Void in
                    if (isDone) {
                        self.tableView.reloadData()
                        self.refreshControl!.endRefreshing()
                    } else {
                        self.refreshControl!.endRefreshing()
                        print("error")
                    }
                }
            } else {
                self.refreshControl!.endRefreshing()
                print("error")
            }
        }
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "room_uuid", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        
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
        cell.configure(actor.valueForKey("name")!.description, room: loxone.getRoomByUuid(actor.valueForKey("room_uuid")!.description))
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

}