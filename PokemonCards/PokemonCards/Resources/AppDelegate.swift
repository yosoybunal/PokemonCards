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
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    let navVC = UINavigationController(rootViewController: ViewController())
    navVC.navigationBar.prefersLargeTitles = true
    navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
    window.rootViewController = navVC

    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}

