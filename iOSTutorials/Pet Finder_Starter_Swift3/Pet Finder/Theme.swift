//
//  Theme.swift
//  Pet Finder
//
//  Created by 葛佳佳 on 2017/7/4.
//  Copyright © 2017年 Ray Wenderlich. All rights reserved.
//

import UIKit

enum Theme: Int {
  
  case `default`, dark, graphical
  
  private enum Keys {
    static let selectedTheme = "SelectedTheme"
  }
  
  static var current: Theme {
    let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
    return Theme(rawValue: storedTheme) ?? .default
  }
  
  var mainColor: UIColor {
    switch self {
    case .default:
      return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    case .dark:
      return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    case .graphical:
      return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
    }
  }
  
  func apply() {
    
    UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
    UserDefaults.standard.synchronize()
    
    UIApplication.shared.delegate?.window??.tintColor = mainColor;
    
    UINavigationBar.appearance().barStyle = barStyle
    UINavigationBar.appearance().setBackgroundImage(navigationBackgroundImage, for: .default)

    UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")

    UITabBar.appearance().barStyle = barStyle
    UITabBar.appearance().backgroundImage = tabbarBackgroundImage
    
    let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
    let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 2.0, 0, 2.0))
    UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
    
  }
  
  var barStyle: UIBarStyle {
    switch self {
    case .default, .graphical:
      return .default
    case .dark:
      return .black
    }
  }
  
  var navigationBackgroundImage: UIImage? {
    return self == .graphical ? UIImage(named: "navBackground") : nil
  }
  
  var tabbarBackgroundImage: UIImage? {
    return self == .graphical ? UIImage(named: "tabBarBackground") : nil
  }
		
  
}
