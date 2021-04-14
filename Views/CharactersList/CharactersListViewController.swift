//
//  ViewController.swift
//  openbank-dev-test
//
//  Created by Carlos Martinez on 13/4/21.
//

import UIKit

class CharactersListViewController: UIViewController {

  private lazy var charactersListCollectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    cv.backgroundColor = .clear
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.contentInset.top = 10
    cv.register(CharactersListCell.self, forCellWithReuseIdentifier: CharactersListCell.reuseIdentifier)
    cv.delegate = self
    return cv
  }()
  
  private lazy var errorLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .body)
    lbl.adjustsFontForContentSizeCategory = true
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textAlignment = .center
    lbl.numberOfLines = 0
    lbl.textColor = .systemGray
    lbl.text = "There was an error retrieving characters. Try again later"
    lbl.isHidden = true
    return lbl
  }()
  
  private var dataSource: UICollectionViewDiffableDataSource<Int, Character>?
  private let viewModel = CharactersListViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationItem.title = "Marvel characters"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    view.addSubview(charactersListCollectionView)
    view.addSubview(errorLabel)
    
    NSLayoutConstraint.activate([
      charactersListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      charactersListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      charactersListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      charactersListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    ])
    
    createDataSource()
    
    viewModel.charactersDidUpdate = { [weak self] characters in
      guard let self = self else { return }
      
      self.hideSpinner()
      
      if let chars = characters {
        self.applyDataSource(withCharacters: chars)
      } else {
        self.errorLabel.isHidden = false
        self.charactersListCollectionView.isHidden = true
      }
    }
    
    showSpinner()
    viewModel.fetchCharacters()
  }
  
  private func createDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Int, Character>(
      collectionView: charactersListCollectionView,
      cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharactersListCell.reuseIdentifier, for: indexPath) as? CharactersListCell else {
          fatalError("CharactersListCell not configured")
        }
        cell.config(forCharacter: item)
        return cell
      })
  }
  
  private func applyDataSource(withCharacters characters: [Character]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, Character>()
    snapshot.appendSections([0])
    snapshot.appendItems(characters, toSection: 0)
    dataSource?.apply(snapshot)
  }
  
  private func createLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
    layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
    
    let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
    
    let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
    
    let section = NSCollectionLayoutSection(group: layoutGroup)
    return UICollectionViewCompositionalLayout(section: section)
  }
}

extension CharactersListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let item = self.dataSource?.itemIdentifier(for: indexPath),
       let id = item.id {
      
      let detailViewModel = CharacterDetailViewModel(withCharacterId: id)
      let detailVC = CharacterDetailViewController(withViewModel: detailViewModel)
      
      present(detailVC, animated: true)
    }
  }
}
