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

    // MARK: - Search Navigation
    let rootViewController = SearchResultsViewController()
    rootViewController.title = "Search"
    let searchNavigation = UINavigationController(rootViewController: rootViewController)
    searchNavigation.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
    searchNavigation.navigationBar.prefersLargeTitles = true

    // MARK: - Favorite Navigation
    let storyboard = UIStoryboard(name: "Favorite", bundle: nil)
    guard let favoriteNavigation = storyboard.instantiateInitialViewController() as? UINavigationController else { return }
    favoriteNavigation.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "bolt.heart.fill"), tag: 2)
    guard let favoriteVC = favoriteNavigation.topViewController as? FavoriteViewController else { return }
    favoriteVC.title = "Favorites"

    // MARK: - All Navigation View Controllers
    setViewControllers([searchNavigation, favoriteNavigation], animated: false)
  }
}
