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

    @IBOutlet weak var editActorButton: UIBarButtonItem!

    @IBAction func editPressed(sender: AnyObject) {
        if self.tableView.editing {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: false)
        }
    }
    
    override func viewDidLoad() {
        managedContext = appDelegate.managedObjectContext
        loxone.managedContext = appDelegate.managedObjectContext
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshOrOpenSettings()
        populateTableData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshOrOpenSettings", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: nil, object: nil)
    }
    
    func refreshOrOpenSettings() {
        if(loxone.settingsEntered() || self.actors.count > 0) {
            refreshControl!.removeTarget(self, action: Selector("enterData"), forControlEvents: UIControlEvents.ValueChanged)
            refreshControl!.addTarget(self, action: Selector("loadData"), forControlEvents: UIControlEvents.ValueChanged)
        } else {
            refreshControl!.addTarget(self, action: Selector("enterData"), forControlEvents: UIControlEvents.ValueChanged)
        }
        self.refreshControl = refreshControl
    }
    
    func populateTableData() {
        let fetchRequest = NSFetchRequest(entityName: "Actor")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "room_uuid", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            actors = results as! [NSManagedObject]
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
        
        if actors.count == 0 {
            let alert = UIAlertController(title: NSLocalizedString("NO_ACTORS_FOUND", comment: "No actors found"), message: NSLocalizedString("PLEASE_PULL_REFRESH", comment: "Please pull the list down to refresh the actors."), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
                        self.refreshControl!.endRefreshing()
                        self.populateTableData()
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ActorCell
        let actor = actors[indexPath.row]
        cell.configure(actor as? Actor, room: loxone.getRoomByUuid(actor.valueForKey("room_uuid")!.description))
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                
                managedContext.deleteObject(self.actors[indexPath.row])
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    NSLog("Could not save the actor. Error: \(error)")
                }
                
                self.actors.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.reloadData()
                
            default:
                return
            }
    }
    

}