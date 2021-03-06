//
//  ActorDetailsController.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 12.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//

import UIKit
import CoreData

class ActorDetailsController: UIViewController {
    
    var actor: Actor?
    var managedObjectContext: NSManagedObjectContext? = nil
    var loxone = Loxone()

    @IBOutlet weak var onButton: UIButton!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var dimmerSlider: UISlider!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func offPressed(sender: AnyObject) {
        loxone.tellLoxone(actor!.name!, uuid: actor!.uuid!, onOff: "off", scene: "")
        dimmerSlider.value = 0
        actor?.used()
    }
    
    @IBAction func onPressed(sender: AnyObject) {
        loxone.tellLoxone(actor!.name!, uuid: actor!.uuid!, onOff: "on", scene: "")
        dimmerSlider.value = 100
        actor?.used()
    }
    
    @IBAction func dimmerValueChanged(dimmer: UISlider) {
        loxone.tellLoxone(actor!.name!, uuid: actor!.uuid!, onOff: "on", scene: "", dimmValue: Int(dimmer.value))
    }
    
    @IBAction func doneSettingDimmerValue(dimmer: UISlider) {
        actor?.used()
    }
    
    // TODO: refactor into model
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configureView()
    }
    
    func configureView() {
        loxone.managedContext = self.managedObjectContext!
        if let name = actor!.name {
            nameLabel.text = name
        }
        if let room_uuid = actor!.room_uuid {
            roomLabel.text = loxone.getRoomByUuid(room_uuid)
        }
        if let dimmable = actor!.isDimmable {
            dimmerSlider.hidden = !Bool(dimmable)
        }
        if let isFavorite = actor!.isFavorite {
            favoriteSwitch.setOn(Bool(isFavorite), animated: true)
        }
        if let scene = actor!.scene {
            if scene != "" {
                offButton.hidden = true
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editActor" {
            (segue.destinationViewController as! EditActorController).actor = actor
            (segue.destinationViewController as! EditActorController).managedObjectContext = managedObjectContext
        }
    }
    
    
}