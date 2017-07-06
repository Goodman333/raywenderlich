//
//  CardTableViewCell.swift
//  CardTilt
//
//  Created by Ray Fix on 6/25/14.
//  Edited by Ray Fix on 4/12/15.
//  Copyright (c) 2014-2015 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

class CardTableViewCell: UITableViewCell {
  
  @IBOutlet var mainView: UIView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var locationLabel: UILabel!
  @IBOutlet var aboutLabel: UILabel!
  @IBOutlet var profilePictureView: UIImageView!
  @IBOutlet var webLabel: UILabel!
  @IBOutlet var webButton: UIButton!
  @IBOutlet var twitterButton: UIButton!
  @IBOutlet var twitterImage: UIImageView!
  @IBOutlet var facebookButton: UIButton!
  @IBOutlet var facebookImage: UIImageView!
  var twitter:String?
  var facebook:String?
  
  func useMember(_ member:Member) {
    // Round those corners
    mainView.layer.cornerRadius = 10;
    mainView.layer.masksToBounds = true;
    
    // Fill in the data
    nameLabel.text = member.name
    titleLabel.text = member.title
    locationLabel.text = member.location
    aboutLabel.text = member.about
    profilePictureView.image = UIImage(named: member.imageName!)
    
    // Fill the buttons and show or hide them
    webLabel.text = member.web
    
    if let twitterURLString = member.twitter {
      twitterImage.isHidden = false
      twitter = twitterURLString
    }
    else {
      twitterImage.isHidden = true
      twitter = nil
    }
    
    if let facebookURLString = member.facebook {
      facebookImage.isHidden = false
      facebook = facebookURLString
    }
    else {
      facebookImage.isHidden = true
      facebook = nil
    }
  }
  
  func jumpTo(_ URLString:String?) {
    if let URL = URL(string: URLString!) {
      UIApplication.shared.openURL(URL)
    }
  }
  
  @IBAction func webButtonTapped(_ sender: AnyObject) {
    jumpTo(webLabel.text)
  }
  
  @IBAction func twitterButtonTapped(_ sender: AnyObject) {
    jumpTo(twitter)
  }
  
  @IBAction func facebookButtonTapped(_ sender: AnyObject) {
    jumpTo(facebook)
  }
}