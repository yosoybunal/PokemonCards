//
//  FavoriteViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

class FavoriteViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemYellow
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let items = UserDefaults.standard.retrieve(object: [SearchResultCellViewModel].self, fromKey: "Favorites")
    print("favorites are: ", items)
  }
}
