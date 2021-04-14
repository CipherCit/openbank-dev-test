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
    cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
    return cv
  }()
  
  private var dataSource: UICollectionViewDiffableDataSource<Int, Character>?
  private let viewModel = CharactersListViewModel()
  private var spinner = UIActivityIndicatorView(style: .large)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationItem.title = "Marvel characters"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    view.addSubview(charactersListCollectionView)
    view.addSubview(spinner)
    
    spinner.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      charactersListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      charactersListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      charactersListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      charactersListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    createDataSource()
    
    viewModel.charactersDidUpdate = { [weak self] characters in
      guard let self = self else { return }
      
      self.spinner.isHidden = true
      self.spinner.stopAnimating()
      
      if let chars = characters {
        self.applyDataSource(withCharacters: chars)
      } else {
        
      }
    }
    
    spinner.startAnimating()
    viewModel.fetchCharacters()
  }
  
  private func createDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Int, Character>(
      collectionView: charactersListCollectionView,
      cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
        /*guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) else {
          return nil
        }*/
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .red
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
    // layoutGroup.interItemSpacing = .fixed(10)
    
    let section = NSCollectionLayoutSection(group: layoutGroup)
    return UICollectionViewCompositionalLayout(section: section)
  }
}

