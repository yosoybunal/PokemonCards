//
//  FavoriteViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

class FavoriteViewController: UIViewController {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var longPressText: UILabel!

  private let refreshControl = UIRefreshControl()
  private var searchViewModels = [SearchResultCellViewModel]()
  private let notificationView = NotificationView()

  // MARK: - VC Lifecycle

  override func viewDidLoad() {

    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    longPressText.text = "Click long to delete an item and pull to refresh!"
    refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    collectionView.alwaysBounceVertical = true
    collectionView.refreshControl = refreshControl
    collectionView.reloadData()
    notificationView.configureNotificationView(view: view)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let items = UserDefaults.standard.retrieve(object: [SearchResultCellViewModel].self, fromKey: "Favorites")
    guard let items = items else { return }
    searchViewModels = items.compactMap({
      SearchResultCellViewModel(name: $0.name , imageUrl: $0.imageUrl)
    })
    collectionView.reloadData()
  }

  // MARK: - Pull to Refresh
  @objc private func didPullToRefresh(_ sender: Any) {
    let items = UserDefaults.standard.retrieve(object: [SearchResultCellViewModel].self, fromKey: "Favorites")
    guard let items = items else { return }
    searchViewModels = items.compactMap({
      SearchResultCellViewModel(name: $0.name , imageUrl: $0.imageUrl)
    })
    collectionView.reloadData()
    refreshControl.endRefreshing()
  }

  // MARK: - Handle Long Press

  @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state == .began {
      let location = gestureRecognizer.location(in: collectionView)

      if let indexPath = collectionView.indexPathForItem(at: location) {
        guard var retrievedItems = UserDefaults.standard.retrieve(object: [SearchResultCellViewModel].self, fromKey: "Favorites") else {return}

        if !retrievedItems.contains(searchViewModels[indexPath.row]) {
          retrievedItems.append(searchViewModels[indexPath.row])
          UserDefaults.standard.save(customObject: retrievedItems, inKey: "Favorites")
          notificationView.showNotification(message: "Item added!", view: view)
        } else {
          retrievedItems.removeAll { $0 == searchViewModels[indexPath.row] }
          UserDefaults.standard.save(customObject: retrievedItems, inKey: "Favorites")
          notificationView.showNotification(message: "Item removed!", view: view)
        }
      }
    }
  }
}

// MARK: - CW DataSource

extension FavoriteViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchViewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCollectionViewCell.identifier, for: indexPath)
            as? FavoritesCollectionViewCell else { return UICollectionViewCell()}
    cell.configure(viewModel: searchViewModels[indexPath.row])
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    cell.addGestureRecognizer(longPressGesture)
    return cell
  }
}
