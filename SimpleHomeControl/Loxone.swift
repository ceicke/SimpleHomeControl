//
//  Loxone.swift
//  HomeControl
//
//  Created by Christoph Eicke on 25.11.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
import Alamofire

class Loxone {
    
    var managedContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    func tellLoxone(actor:NSString, uuid:NSString, onOff:NSString, scene:NSString = "", dimmValue:Int = -1) {
        
        let loxoneLocalIP:NSString = NSUserDefaults.standardUserDefaults().valueForKey("server_ip") as! NSString
        let username:NSString = NSUserDefaults.standardUserDefaults().valueForKey("username") as! NSString
        let password:NSString = NSUserDefaults.standardUserDefaults().valueForKey("password") as! NSString
        
        var url:NSURL = NSURL(string: "")!
        
        if scene == "" {
            if dimmValue == -1 {
                url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/\(uuid)/\(onOff)")!
            } else {
                url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/\(uuid)/\(dimmValue)")!
            }
        } else {
            if dimmValue == -1 {
                url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/\(uuid)/\(scene)/\(onOff)")!
            } else {
                url = NSURL(string: "http://\(username):\(password)@\(loxoneLocalIP)/dev/sps/io/\(uuid)/\(scene)/\(dimmValue)")!
            }
        }
        
        debugPrint(url)
                
        if url != "" {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    if httpResponse.statusCode != 200 {
                        NSLog("ERROR \(httpResponse.statusCode)")
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func settingsEntered() -> Bool {
        var appDefaults = Dictionary<String, AnyObject>()
        appDefaults["server_ip"] = "333.333.333.333"
        appDefaults["username"] = "2601"
        appDefaults["password"] = "2602"
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let loxoneLocalIP:NSString = NSUserDefaults.standardUserDefaults().valueForKey("server_ip") as! NSString
        let username:NSString = NSUserDefaults.standardUserDefaults().valueForKey("username") as! NSString
        let password:NSString = NSUserDefaults.standardUserDefaults().valueForKey("password") as! NSString
        
        if loxoneLocalIP == "333.333.333.333" || username == "2601" || password == "2602" {
            return false
        } else {
            return true
        }
    }
    
    func getRooms(callback: ((isDone: Bool)->Void)?) {
        let loxoneLocalIP:NSString = NSUserDefaults.standardUserDefaults().valueForKey("server_ip") as! NSString
        let username:NSString = NSUserDefaults.standardUserDefaults().valueForKey("username") as! NSString
        let password:NSString = NSUserDefaults.standardUserDefaults().valueForKey("password") as! NSString
        
        var configEndpoint = "http://\(username):\(password)@\(loxoneLocalIP)/data/loxapp3.json"

        configEndpoint = "http://81.169.247.199/data/loxapp3.json"
        
        Alamofire.request(.GET, configEndpoint)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error)
                    callback?(isDone: false)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let json = JSON(value)
                    for (uuid, room):(String, JSON) in json["rooms"] {
                        self.insertRoom(uuid, name: room["name"].string!)
                    }
                    callback?(isDone: true)

                }
        }
    }
    
    func insertRoom(uuid: String, name: String) {
        if !recordExists(uuid, recordType: "Rooms") {
            let entity =  NSEntityDescription.entityForName("Rooms", inManagedObjectContext:managedContext)
            let room = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            room.setValue(uuid, forKey: "uuid")
            room.setValue(name, forKey: "name")
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                NSLog("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func getControls(callback: ((isDone: Bool)->Void)?) {
        let loxoneLocalIP:NSString = NSUserDefaults.standardUserDefaults().valueForKey("server_ip") as! NSString
        let username:NSString = NSUserDefaults.standardUserDefaults().valueForKey("username") as! NSString
        let password:NSString = NSUserDefaults.standardUserDefaults().valueForKey("password") as! NSString
        
        var configEndpoint = "http://\(username):\(password)@\(loxoneLocalIP)/data/loxapp3.json"
        
        // configEndpoint = "http://81.169.247.199/data/loxapp3.json"
        
        Alamofire.request(.GET, configEndpoint)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error)
                    callback?(isDone: false)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    let json = JSON(value)
                    for (_, subJson):(String, JSON) in json["controls"] {
                        if subJson["type"].string == "Switch" {
                            self.insertActor(subJson["uuidAction"].string!, name: subJson["name"].string!, room_uuid: subJson["room"].string!, dimmable: false)
                        }
                        if subJson["type"].string == "Dimmer" {
                            self.insertActor(subJson["uuidAction"].string!, name: subJson["name"].string!, room_uuid: subJson["room"].string!, dimmable: true)
                        }
                        if subJson["type"].string == "LightController" {
                            for (_, subSubJson):(String, JSON) in subJson["subControls"] {
                                // TODO: refactor because code is same as above
                                if subSubJson["type"].string == "Switch" {
                                    self.insertActor(subSubJson["uuidAction"].string!, name: subSubJson["name"].string!, room_uuid: subJson["room"].string!, dimmable: false)
                                }
                                if subSubJson["type"].string == "Dimmer" {
                                    self.insertActor(subSubJson["uuidAction"].string!, name: subSubJson["name"].string!, room_uuid: subJson["room"].string!, dimmable: true)
                                }

                            }
                        }
                    }
                    callback?(isDone: true)
                    
                }
        }
    }
    
    func insertActor(uuid: String, name: String, room_uuid: String, dimmable: Bool) {
        if !recordExists(uuid, recordType: "Actor") {
            let entity =  NSEntityDescription.entityForName("Actor", inManagedObjectContext:managedContext)
            let actor = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            actor.setValue(uuid, forKey: "uuid")
            actor.setValue(name, forKey: "name")
            actor.setValue(room_uuid, forKey: "room_uuid")
            actor.setValue(0, forKey: "isFavorite")
            if dimmable {
                actor.setValue(1, forKey: "isDimmable")
            } else {
                actor.setValue(0, forKey: "isDimmable")
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                NSLog("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func recordExists(uuid: String, recordType: String) -> Bool {
        let withUuid = NSPredicate(format: "uuid = %@", uuid)
        let fetchRequest = NSFetchRequest(entityName: recordType)
        fetchRequest.predicate = withUuid
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results.count > 0
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
            return false
        }
    }
    
    func getRoomByUuid(uuid: String) -> String {
        let withUuid = NSPredicate(format: "uuid = %@", uuid)
        let fetchRequest = NSFetchRequest(entityName: "Rooms")
        fetchRequest.predicate = withUuid
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let room = results[0] as! NSManagedObject
            return room.valueForKey("name") as! String
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
            return ""
        }

    }

}