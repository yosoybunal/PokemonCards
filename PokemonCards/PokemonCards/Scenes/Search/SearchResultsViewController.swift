//
//  SearchResultsViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit

class SearchResultsViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var longPressText: UILabel!

  // MARK: - Private Properties

  private var searchViewModels = [SearchResultCellViewModel]() {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.collectionView.reloadData()
        self?.longPressText.text = "Click long on cards to add to favorites or click once to see its details!"
      }
    }
  }

  private let notificationView = NotificationView()
  private var cardDetailViewModels = [CardDetailCellViewModel]()
  private var searchController: UISearchController
  private var viewModel = SearchResultViewModel()


  init?(coder: NSCoder, searchController: UISearchController) {
    self.searchController = searchController
    super.init(coder: coder)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - VC Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    setupUI()
  }

  // MARK: - Functions

  private func setupUI() {
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    searchController.searchBar.placeholder = "Enter a HP up to 3 digits."
    view.backgroundColor = .systemBackground
    searchController.searchBar.keyboardType = .numberPad
    addToolBar()
    notificationView.configureNotificationView(view: view)
  }

  private func addToolBar() {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
    toolbar.items = [flexibleSpace, doneButton]
    searchController.searchBar.inputAccessoryView = toolbar
  }

  @objc private func doneButtonTapped() {
    searchController.searchBar.resignFirstResponder()
  }

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

  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text,
      !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    viewModel.fetchData(with: query)
    collectionView.setContentOffset(CGPoint.zero, animated: true)
  }
}

// MARK: - CW DataSource & Delegate

extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    let cardDetailStoryboard = UIStoryboard(name: "CardDetail", bundle: nil)
    let vc = cardDetailStoryboard.instantiateViewController(identifier: "CardDetail", creator: { coder in
      return CardDetailViewController(coder: coder, card: card)
    })
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension SearchResultsViewController: SearchResultViewModelDelegate {

  func getSearchResults(cards: [SearchResultCellViewModel]) {
    searchViewModels = cards
  }

  func getCardDetails(cards: [CardDetailCellViewModel]) {
    cardDetailViewModels = cards
  }
}
