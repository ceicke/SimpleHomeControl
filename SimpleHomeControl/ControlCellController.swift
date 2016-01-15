//
//  ControlCellController.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 12.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//

import UIKit
import CoreData

class ControlCellController: UICollectionViewCell {
    
    var actor: Actor?
    
    var loxone = Loxone()
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var onButton: UIButton!
    @IBOutlet weak var dimmerSlider: UISlider!
    
    @IBAction func offPressed(sender: AnyObject) {
        loxone.tellLoxone(actor!.name!, uuid: actor!.uuid!, onOff: "off", scene: "")
        dimmerSlider.value = 0
    }
    
    @IBAction func onPressed(sender: AnyObject) {
        loxone.tellLoxone(actor!.name!, uuid: actor!.uuid!, onOff: "on", scene: "")
        dimmerSlider.value = 100
    }
    
    @IBAction func dimmValueChanged(dimmer: UISlider) {
        loxone.tellLoxone(actor!.name!, uuid: actor!.uuid!, onOff: "on", scene: "", dimmValue: Int(dimmer.value))
    }
    
    func configureView(managedContext: NSManagedObjectContext) {
        loxone.managedContext = managedContext
        if let name = actor!.name {
            actorNameLabel.text = name
        }
        if let room_uuid = actor!.room_uuid {
            roomLabel.text = loxone.getRoomByUuid(room_uuid)
        }
        if let dimmable = actor!.isDimmable {
            dimmerSlider.hidden = !Bool(dimmable)
        }
        if let scene = actor!.scene {
            if scene != "" {
                offButton.hidden = true
            }
        }
    }
    
    
}
