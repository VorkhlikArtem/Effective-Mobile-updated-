//
//  ProductDetailsViewController.swift
//  EcommerceConcept
//
//  Created by Артём on 05.12.2022.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<DetailCVViewModel.Section, DetailCVViewModel.Item>?
    
    var productDetailsBottomView: ProductDetailsBottomView!
    let networkManager = DataFetcher()
    var model: ProductDetailModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupNavigationBar()
        setupCollectionView()
        createDataSource()
        networkManager.getDetail { [weak self] productDetailModel in
            guard let self = self,
                  let productDetailModel = productDetailModel else {return}
            self.model = productDetailModel
            DispatchQueue.main.async {
                self.setupButtomView()
                self.reloadData()
            }
        }
       // reloadData()
    }
    
    // MARK: - setup Navigation Bar
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "MarkPro-Medium", size: 18)
        titleLabel.text = "Product Details"
        
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = generateBarButtonItem(withColor: .blackTextColor, andImage: "back", action: #selector(goBack))
        navigationItem.rightBarButtonItem = generateBarButtonItem(withColor: .orangeColor, andImage: "cart")
    }
    
    private func generateBarButtonItem(withColor color: UIColor, andImage image: String, action: Selector? = nil) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: image), for: .normal)
        button.frame = .init(x: 0, y: 0, width: 37, height: 37)
        button.backgroundColor = color
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        let barButtomItem = UIBarButtonItem(customView: button)
        return barButtomItem
    }
    

    
    // MARK: - setup Collection View
    private func setupCollectionView() {

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        collectionView.isScrollEnabled = false
        collectionView.register(ProductDetailCVCell.self, forCellWithReuseIdentifier: ProductDetailCVCell.reuseId)
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<DetailCVViewModel.Section, DetailCVViewModel.Item>()
        snapShot.appendSections([.images])
        let items = model.images.map { DetailCVViewModel.Item.init(imageUrlString: $0)}
        snapShot.appendItems(items, toSection: .images)
   
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    // MARK: - setup Bottom View
    func setupButtomView() {
        let productDetailBottomViewModel = ProductDetailBottomViewModel(productDetailModel: model)
        productDetailsBottomView = ProductDetailsBottomView(productDetailBottomViewModel: productDetailBottomViewModel)
        productDetailsBottomView.backgroundColor = .white
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        view.addSubviewAtTheBottom(subview: productDetailsBottomView, bottomOffset: tabBarHeight)
        
    }
}

// MARK: - Create Data Source

extension ProductDetailsViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailCVCell.reuseId, for: indexPath) as? ProductDetailCVCell else { fatalError("Unable to dequeue cell")}
            cell.configure(with: item.imageUrlString)
            return cell
        })
    }
}

// MARK: - create Compositional Layout
extension ProductDetailsViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {  section, layoutEnvironment in
                return self.createSectionLayout()
        }
        return layout
    }
    
    private func createSectionLayout() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalWidth(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 30, leading: 0, bottom: 0, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }

        return section
    }
}

// MARK: - Routing
extension ProductDetailsViewController {
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

