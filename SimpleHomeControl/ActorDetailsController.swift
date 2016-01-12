//
//  ActorDetailsController.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 12.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ActorDetailsController: UIViewController {
    
    var actor: Actor?
    var managedObjectContext: NSManagedObjectContext? = nil

    
    @IBOutlet weak var onButton: UIButton!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var dimmerSlider: UISlider!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func isFavoriteChanged(sender: UISwitch) {
        actor?.setValue(sender.on, forKey: "isFavorite")
        
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            NSLog("Could not save the actor. Error: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        if let name = actor!.name {
            nameLabel.text = name
        }
        if let room = actor!.room {
            roomLabel.text = room
        }
        if let dimmable = actor!.dimmable {
            dimmerSlider.hidden = !Bool(dimmable)
        }
        if let isScene = actor!.isScene {
            dimmerSlider.hidden = Bool(isScene)
            offButton.hidden = Bool(isScene)
        }
        if let isFavorite = actor!.isFavorite {
            favoriteSwitch.setOn(Bool(isFavorite), animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}