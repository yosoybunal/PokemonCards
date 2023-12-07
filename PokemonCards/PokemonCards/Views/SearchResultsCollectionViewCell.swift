//
//  SearchResultsCollectionViewCell.swift
//  PokemonCards
//
//  Created by Berkay Unal on 6.12.2023.
//

import UIKit
import SDWebImage

protocol CollectionViewItemDelegate: AnyObject {
  func itemTapped(cell: SearchResultsCollectionViewCell)
}

class SearchResultsCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var textLabel: UILabel!

  private var isFinished = false
  private var loadingBarAnimator: UIViewPropertyAnimator?
  static let identifier = "cell"
  weak var delegate: CollectionViewItemDelegate?

// MARK: - Configure Cell

  func configure(viewModel: SearchResultCellViewModel) {
    let transformer = SDImageResizingTransformer(size: CGSize(width: 150, height: 180), scaleMode: .fill)
    imageView.sd_setImage(with: URL(string: viewModel.imageUrl), placeholderImage: nil, context: [.imageTransformer: transformer])
    textLabel.text = viewModel.name
  }
}

//MARK: - Loading Animations

extension SearchResultsCollectionViewCell {

  private func startLoadingAnimation() {
    loadingBarAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [weak self] in
      self?.layoutIfNeeded()
    }

    loadingBarAnimator?.addCompletion { [weak self] position in
      guard let cell = self else { return }
      if position == .end {
        self?.isFinished = true
        self?.loadingBarAnimator = nil
        self?.delegate?.itemTapped(cell: cell)
      }
    }
    loadingBarAnimator?.startAnimation()
  }

  private func stopLoadingAnimation() {
    loadingBarAnimator?.stopAnimation(true)
    loadingBarAnimator?.finishAnimation(at: .current)
    loadingBarAnimator = nil

    UIView.animate(withDuration: 0.15) {
      self.layoutIfNeeded()
    }
  }
}

//MARK: - Gesture Recognizer

extension SearchResultsCollectionViewCell {
  private func configureGesture() {
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    addGestureRecognizer(longPressGesture)
  }

  @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
    switch gestureRecognizer.state {
    case .began:
      isFinished = false
      startLoadingAnimation()
    case .ended:
      if !isFinished {
        stopLoadingAnimation()
      }
    default:
      break
    }
  }
}
