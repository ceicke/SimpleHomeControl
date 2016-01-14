//
//  ActorCell.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 12.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//

import UIKit

class ActorCell: UITableViewCell {
    
    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var roomName: UILabel!
    
    func configure(actor: String?, room: String?) {
        actorName.text = actor
        roomName.text = room
    }
}