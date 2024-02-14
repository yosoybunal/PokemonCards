//
//  SearchResultsViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

protocol ResultDelegate: AnyObject {

  func didTapCell(card: CardDetailCellViewModel)
}

class SearchResultsViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var longPressText: UILabel!

  private var searchViewModels = [SearchResultCellViewModel]() {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.collectionView.reloadData()
      }
    }
  }

  let notificationView = UIView()
  let notificationLabel = UILabel()

  private var cardDetailViewModels = [CardDetailCellViewModel]()
  weak var delegate: ResultDelegate?
  var searchController: UISearchController!
  private var viewModel = SearchResultViewModel()

  // MARK: - VC Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    initiliazeSearchResultsStoryboard()
    setupUI()
  }

  private func setupUI() {
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    searchController.searchBar.placeholder = "Enter a HP up to 3 digits."
    view.backgroundColor = .systemBackground
    searchController.searchBar.keyboardType = .numberPad
    addToolBar()

    // Configure notification view
    notificationLabel.textAlignment = .center
    notificationLabel.textColor = .systemBackground
    notificationLabel.translatesAutoresizingMaskIntoConstraints = false
    notificationLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    notificationView.addSubview(notificationLabel)
    NSLayoutConstraint.activate([
      notificationLabel.centerXAnchor.constraint(equalTo: notificationView.centerXAnchor),
      notificationLabel.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor)
    ])

    notificationView.backgroundColor = .secondaryLabel
    notificationView.frame = CGRect(x: 5, y: view.frame.height - 125, width: view.frame.width - 10, height: 40)
    notificationView.layer.cornerRadius = 15
    notificationView.isHidden = true
    view.addSubview(notificationView)
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

  private func addToolBar() {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
    toolbar.items = [flexibleSpace, doneButton]
    searchController.searchBar.inputAccessoryView = toolbar
  }

  @objc func doneButtonTapped() {
    searchController.searchBar.resignFirstResponder()
  }

  private func initiliazeSearchResultsStoryboard() {
    let searchResultsStoryboard = UIStoryboard(name: "SearchResults", bundle: nil)
    guard let searchResultsVC = searchResultsStoryboard.instantiateInitialViewController() as? SearchResultsViewController else {
      fatalError("Unable to Instantiate Onboarding View Controller")
    }
    searchResultsVC.delegate = self
    self.searchController = UISearchController(searchResultsController: searchResultsVC)
  }

  func getSearchResults(cards: [SearchResultCellViewModel]) {
    searchViewModels = cards
  }

  func getCardDetails(cards: [CardDetailCellViewModel]) {
    cardDetailViewModels = cards
  }

  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text,
          !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    viewModel.fetchData(for: searchController, with: query)
  }
}

// MARK: - CW DataSource & Delegate

extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(searchViewModels.count)
    return searchViewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath)
            as? SearchResultsCollectionViewCell else { return UICollectionViewCell()}
    cell.configure(viewModel: searchViewModels[indexPath.row])
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    cell.addGestureRecognizer(longPressGesture)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let card = cardDetailViewModels[indexPath.row]
    delegate?.didTapCell(card: card)
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

extension SearchResultsViewController: ResultDelegate {
  func didTapCell(card: CardDetailCellViewModel) {
    let cardDetailStoryboard = UIStoryboard(name: "CardDetail", bundle: nil)
    let vc = cardDetailStoryboard.instantiateViewController(identifier: "CardDetail", creator: { coder in
      return CardDetailViewController(coder: coder, card: card)
    })
    navigationController?.pushViewController(vc, animated: true)
  }
}
