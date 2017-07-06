//
//  Member.swift
//  CardTilt
//
//  Created by Ray Fix on 6/25/14.
//  Edited by Ray Fix on 4/12/15.
//  Copyright (c) 2014-2015 Razeware LLC. All rights reserved.
//

import Foundation

class Member {
  let imageName: String?
  let name: String?
  let title: String?
  let location: String?
  let about: String?
  let web: String?
  let facebook: String?
  let twitter: String?
  
  init(dictionary:NSDictionary) {
    imageName = dictionary["image"]    as? String
    name      = dictionary["name"]     as? String
    title     = dictionary["title"]    as? String
    location  = dictionary["location"] as? String
    web       = dictionary["web"]      as? String
    facebook  = dictionary["facebook"] as? String
    twitter   = dictionary["twitter"]  as? String
    
    // fixup the about text to add newlines
    let unescapedAbout = dictionary["about"] as? String
    about = unescapedAbout?.replacingOccurrences(of: "\\n", with: "\n", options: .caseInsensitive, range: nil)
  }
  
    class func loadMembersFromFile(_ path:String) -> [Member]
    {
        var members:[Member] = []
        
        if let path = Bundle.main.path(forResource: "TeamMembers", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String:AnyObject]
                let  team = json["team"]
                for field in team as? [AnyObject] ?? [] {
                    let member = Member(dictionary: field as! NSDictionary)
                    members.append(member)
                }
                
                
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        return members
    }
}
