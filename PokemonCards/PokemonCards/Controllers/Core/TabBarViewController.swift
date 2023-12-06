//
//  TabBarViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

class TabBarViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let vc1 = SeachViewController()
    let vc2 = FavoriteViewController()

    vc1.title = "Search"
    vc2.title = "Favorites"

//    vc1.navigationItem.largeTitleDisplayMode = .always
//    vc2.navigationItem.largeTitleDisplayMode = .always

    let nav1 = UINavigationController(rootViewController: vc1)
    let nav2 = UINavigationController(rootViewController: vc2)

    nav1.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
    nav2.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "bolt.heart.fill"), tag: 1)

    nav1.navigationBar.prefersLargeTitles = true
    nav2.navigationBar.prefersLargeTitles = true

    setViewControllers([nav1, nav2], animated: false)
  }
}
