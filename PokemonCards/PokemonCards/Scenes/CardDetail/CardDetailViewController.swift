//
//  CardDetailViewController.swift
//  PokemonCards
//
//  Created by Berkay Unal on 14.02.2024.
//

import UIKit
import SDWebImage

class CardDetailViewController: UIViewController {

  @IBOutlet weak var pokemonNameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!

  var cardDetailsViewModel: CardDetailCellViewModel

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  init?(coder: NSCoder, card: CardDetailCellViewModel) {
    self.cardDetailsViewModel = card
    super.init(coder: coder)
  }

  required init?(coder: NSCoder) {
    fatalError("You must create this view controller with a card.")
  }

  func setupUI() {
    let font = UIFont(name:"Marker Felt", size: 20)
    artistNameLabel.text = "Artist Name: \(cardDetailsViewModel.artist)"
    artistNameLabel.font = font
    pokemonNameLabel.text = "Pokemon Name: \(cardDetailsViewModel.name)"
    pokemonNameLabel.font = font
    imageView.sd_setImage(with: URL(string: cardDetailsViewModel.imageUrlHiRes), completed: nil)
  }
}
