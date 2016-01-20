//
//  ActorCell.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 12.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//

import UIKit

class ActorCell: UITableViewCell {
    
    var actor: Actor!
    
    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var roomName: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        self.actor?.toggleFavorite()
        setFavoritePicture()
    }
    
    func configure(actor: Actor!, room: String?) {
        self.actor = actor
        actorName.text = actor!.valueForKey("name")!.description
        roomName.text = room
        setFavoritePicture()
    }
    
    func setFavoritePicture() {
        if (self.actor!.isFavorite == true) {
            if let image = UIImage(named: "favorite-on") {
                favoriteButton.setBackgroundImage(image, forState: .Normal)
            }
        } else {
            if let image = UIImage(named: "favorite-off") {
                favoriteButton.setBackgroundImage(image, forState: .Normal)
            }
        }
    }
}