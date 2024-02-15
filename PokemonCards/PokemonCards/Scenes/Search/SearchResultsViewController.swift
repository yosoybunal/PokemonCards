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

class SearchResultsViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var longPressText: UILabel!

  // MARK: - Private Properties

  private var searchViewModels = [SearchResultCellViewModel]() {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.collectionView.reloadData()
      }
    }
  }

  private let notificationView = NotificationView()
  private var cardDetailViewModels = [CardDetailCellViewModel]()
  private weak var delegate: ResultDelegate?
  private var searchController: UISearchController!
  private var viewModel = SearchResultViewModel()

  // MARK: - VC Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    initiliazeSearchResultsStoryboard()
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

  private func initiliazeSearchResultsStoryboard() {
    let searchResultsStoryboard = UIStoryboard(name: "SearchResults", bundle: nil)
    guard let searchResultsVC = searchResultsStoryboard.instantiateInitialViewController() as? SearchResultsViewController else {
      fatalError("Unable to Instantiate Onboarding View Controller")
    }
    searchResultsVC.delegate = self
    self.searchController = UISearchController(searchResultsController: searchResultsVC)
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
