//
//  FirstViewController.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 12.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//

import UIKit
import CoreData

class FavoritesController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var actors = [NSManagedObject]()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedContext = appDelegate.managedObjectContext
        
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        let onlyFavorites = NSPredicate(format: "isFavorite = 1")
        let fetchRequest = NSFetchRequest(entityName: "Actor")
        fetchRequest.predicate = onlyFavorites
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            actors = results as! [NSManagedObject]
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actors.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("controlCell", forIndexPath: indexPath) as! ControlCellController
        cell.actor = actors[indexPath.row] as? Actor
        cell.configureView(managedContext)
        return cell
    }


}

