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

  let notificationView = UIView()
  let notificationLabel = UILabel()

  // MARK: - VC Lifecycle

  override func viewDidLoad() {

    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    longPressText.text = "Click long to delete an item and pull to refresh!"
    refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    collectionView.alwaysBounceVertical = true
    collectionView.refreshControl = refreshControl
    collectionView.reloadData()

    // Configure notification view
    notificationLabel.textAlignment = .center
    notificationLabel.textColor = .systemBackground
    notificationLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    notificationLabel.translatesAutoresizingMaskIntoConstraints = false
    notificationView.addSubview(notificationLabel)
    NSLayoutConstraint.activate([
      notificationLabel.centerXAnchor.constraint(equalTo: notificationView.centerXAnchor),
      notificationLabel.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor)
    ])

    notificationView.backgroundColor = .systemGray
    notificationView.frame = CGRect(x: 5, y: view.frame.height - 125, width: view.frame.width - 10, height: 40)
    notificationView.layer.cornerRadius = 15
    notificationView.isHidden = true
    view.addSubview(notificationView)
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
  @objc
  private func didPullToRefresh(_ sender: Any) {
    let items = UserDefaults.standard.retrieve(object: [SearchResultCellViewModel].self, fromKey: "Favorites")
    guard let items = items else { return }
    searchViewModels = items.compactMap({
      SearchResultCellViewModel(name: $0.name , imageUrl: $0.imageUrl)
    })
    collectionView.reloadData()
    refreshControl.endRefreshing()
  }

  // Function to show notification
  func showNotification(message: String) {
    notificationLabel.text = message
    // Show notification with animation
    notificationView.isHidden = false
    UIView.animate(withDuration: 0.3, animations: {
      self.notificationView.frame.origin.y = self.view.frame.height - 125
    }) { _ in
      // Dismiss notification after 2 seconds
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        self.hideNotification()
      }
    }
  }

  // Function to hide notification
  func hideNotification() {
    // Hide notification with animation
    UIView.animate(withDuration: 0.3) {
      self.notificationView.frame.origin.y = self.view.frame.height
    } completion: { _ in
      self.notificationView.isHidden = true
    }
  }
}

// MARK: - DataSource

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

  @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state == .began {
      let location = gestureRecognizer.location(in: collectionView)

      if let indexPath = collectionView.indexPathForItem(at: location) {
        guard var retrievedItems = UserDefaults.standard.retrieve(object: [SearchResultCellViewModel].self, fromKey: "Favorites") else {return}

        if !retrievedItems.contains(searchViewModels[indexPath.row]) {
          retrievedItems.append(searchViewModels[indexPath.row])
          UserDefaults.standard.save(customObject: retrievedItems, inKey: "Favorites")
          showNotification(message: "Item added!")
        } else {
          retrievedItems.removeAll { $0 == searchViewModels[indexPath.row] }
          UserDefaults.standard.save(customObject: retrievedItems, inKey: "Favorites")
          showNotification(message: "Item removed!")
        }
      }
    }
  }
}
