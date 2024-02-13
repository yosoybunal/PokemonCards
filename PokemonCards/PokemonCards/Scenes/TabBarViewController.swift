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

    let vc1 = SearchResultsViewController()
    vc1.title = "Search"
    let nav1 = UINavigationController(rootViewController: vc1)
    nav1.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
    nav1.navigationBar.prefersLargeTitles = true

    let storyboard = UIStoryboard(name: "Favorite", bundle: nil)
    let favoriteNavigation = storyboard.instantiateInitialViewController() as? UINavigationController
    favoriteNavigation?.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "bolt.heart.fill"), tag: 1)

    let favoriteVC = favoriteNavigation?.topViewController as? FavoriteViewController
    favoriteVC?.title = "Favorites"

    setViewControllers([nav1, favoriteNavigation!], animated: false)
  }
}
