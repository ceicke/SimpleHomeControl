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
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var onButton: UIButton!
    @IBOutlet weak var dimmerSlider: UISlider!
    
    @IBAction func offPressed(sender: AnyObject) {
        print("off")
    }
    
    @IBAction func onPressed(sender: AnyObject) {
        print("on")
    }
    
    @IBAction func dimmValueChanged(sender: UISlider) {
        print("slide")
    }
    
    func configureView() {
        if let name = actor!.name {
            actorNameLabel.text = name
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
    }
    
    
}
