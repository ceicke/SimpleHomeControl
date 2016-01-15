//
//  EditActorController.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 15.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditActorController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var actor: Actor!
    var managedObjectContext: NSManagedObjectContext! = nil
    
    var rooms = []
    var selectedRoomUuid: String!
    
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var uuidInputField: UITextField!
    @IBOutlet weak var sceneInputField: UITextField!
    @IBOutlet weak var dimmableSwitch: UISwitch!
    @IBOutlet weak var roomPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.saveValues()
    }
    
    func configureView() {
        if let actorName = actor!.name {
            nameInputField.text = actorName
        }
        if let actorUuid = actor!.uuid {
            uuidInputField.text = actorUuid
        }
        if let scene = actor!.scene {
            sceneInputField.text = scene
        }
        if let isDimmable = actor!.isDimmable {
            dimmableSwitch.enabled = Bool(isDimmable)
        }
        if let roomUuid = actor!.room_uuid {
            selectedRoomUuid = roomUuid
        }
        loadRooms()
        self.roomPicker.dataSource = self;
        self.roomPicker.delegate = self;
        roomPicker.selectRow(getIndexForSelectedRoom(), inComponent: 0, animated: true)

    }
    
    func loadRooms() {
        let fetchRequest = NSFetchRequest(entityName: "Rooms")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            rooms = results as! [NSManagedObject]
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func getIndexForSelectedRoom() -> Int {
        var i = 0
        for room in rooms {
            if room.uuid == selectedRoomUuid {
                return i
            }
            i++
        }
        return i
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rooms.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rooms[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedRoomUuid = rooms[row].uuid
    }
    
    func saveValues() {
        actor.setValue(nameInputField.text, forKey: "name")
        actor.setValue(uuidInputField.text, forKey: "uuid")
        actor.setValue(sceneInputField.text, forKey: "scene")
        actor.setValue(dimmableSwitch.on, forKey: "isDimmable")
        actor.setValue(selectedRoomUuid, forKey: "room_uuid")
        
        do {
            try self.managedObjectContext!.save()
        } catch let error as NSError {
            NSLog("Could not save the actor. Error: \(error)")
            return
        }
    }
    
    
}