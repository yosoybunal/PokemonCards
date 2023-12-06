//
//  AppDelegate.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let controller = UINavigationController(rootViewController: TabBarViewController())
    controller.navigationBar.prefersLargeTitles = false
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
    return true
  }
}

