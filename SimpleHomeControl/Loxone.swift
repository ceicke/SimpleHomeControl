//
//  Loxone.swift
//  HomeControl
//
//  Created by Christoph Eicke on 25.11.15.
//  Copyright © 2015 Christoph Eicke. All rights reserved.
//

import Foundation

class Loxone {
    
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
        
        print(url)
        
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
        
        print(loxoneLocalIP)
        
        if loxoneLocalIP == "333.333.333.333" || username == "2601" || password == "2602" {
            return false
        } else {
            return true
        }
    }

}