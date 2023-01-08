//
//  ProductDetailsViewController.swift
//  EcommerceConcept
//
//  Created by Артём on 05.12.2022.
//

import UIKit
import Combine

class ProductDetailsViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<DetailCVViewModel.Section, DetailCVViewModel.Item>?
    
    var productDetailsBottomView: ProductDetailsBottomView!
    let networkManager = CombineNetworkManager()
    var model: ProductDetailModel!
    
    var cancellable: AnyCancellable?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupNavigationBar()
        
        cancellable = networkManager.getDetail()
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] productDetailModel in
                guard let self = self else {return}
                self.model = productDetailModel
                self.setupButtomView()
                self.setupCollectionView()
                self.createDataSource()
                self.reloadData()
            }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUIOrientation(.portrait)
    }

    // MARK: - Setup Navigation Bar
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
    

    
    // MARK: - Setup Collection View
    private func setupCollectionView() {

        let topBarHeight = (navigationController?.navigationBar.frame.height ?? 0) + (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
      
        view.insertSubview(collectionView, belowSubview: productDetailsBottomView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarHeight),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: productDetailsBottomView.topAnchor )
            
        ])
        collectionView.isScrollEnabled = false
        collectionView.register(ProductDetailCVCell.self, forCellWithReuseIdentifier: ProductDetailCVCell.reuseId)
        collectionView.clipsToBounds = false
    }
    
    // MARK: - Reload Data
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<DetailCVViewModel.Section, DetailCVViewModel.Item>()
        snapShot.appendSections([.images])
        let items = model.images.map { DetailCVViewModel.Item.init(imageUrlString: $0)}
        snapShot.appendItems(items, toSection: .images)
   
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    // MARK: - Setup Bottom View
    func setupButtomView() {
        let productDetailBottomViewModel = ProductDetailBottomViewModel(productDetailModel: model)
        productDetailsBottomView = ProductDetailsBottomView(productDetailBottomViewModel: productDetailBottomViewModel)
        productDetailsBottomView.backgroundColor = .white
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        view.addSubviewAtTheBottom(subview: productDetailsBottomView, bottomOffset: tabBarHeight)
        productDetailsBottomView.clipsToBounds = false
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

// MARK: - Create Compositional Layout
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

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(0.7), heightDimension: .fractionalHeight(0.9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        
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

