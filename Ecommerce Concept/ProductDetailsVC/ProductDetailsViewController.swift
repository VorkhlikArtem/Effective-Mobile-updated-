//
//  ProductDetailsViewController.swift
//  EcommerceConcept
//
//  Created by Артём on 05.12.2022.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    var productDetailsBottomView: ProductDetailsBottomView!
    
    let networkManager = NetworkManager()
    
    var model: ProductDetailModel!
    
    let strings = ["https://avatars.mds.yandex.net/get-mpic/5235334/img_id5575010630545284324.png/orig", "https://www.manualspdf.ru/thumbs/products/l/1260237-samsung-galaxy-note-20-ultra.jpg", "https://shop.gadgetufa.ru/images/upload/52534-smartfon-samsung-galaxy-s20-ultra-12-128-chernyj_1024.jpg", "https://mi92.ru/wp-content/uploads/2020/03/smartfon-xiaomi-mi-10-pro-12-256gb-global-version-starry-blue-sinij-1.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupCollectionView()
        createDataSource()
        networkManager.fetchData(url: NetworkManager.detailUrlString, type: ProductDetailModel.self) { productDetailModel in
            self.model = productDetailModel
            DispatchQueue.main.async {
                self.setup()
                self.reloadData()
            }
        }
        
       // reloadData()
    }
    
    // MARK: - setup Collection View
    private func setupCollectionView() {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
//        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        collectionView.backgroundColor = .yellow
//
  //      view.addSubview(collectionView)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .yellow
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
        collectionView.register(HotSalesCell.self, forCellWithReuseIdentifier: HotSalesCell.reuseId)
        
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapShot.appendSections([.images])
        //let items = model.images.map { Item.init(imageUrlString: $0)}
        let items = strings.map { Item.init(imageUrlString: $0)}
        snapShot.appendItems(items, toSection: .images)
   
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    
    
    
    // MARK: - setup Bottom View
    func setup() {
        let productDetailBottomViewModel = ProductDetailBottomViewModel(productDetailModel: model)
        productDetailsBottomView = ProductDetailsBottomView(productDetailBottomViewModel: productDetailBottomViewModel)
        
        productDetailsBottomView.backgroundColor = .white
        
        
        productDetailsBottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(productDetailsBottomView)
        
        NSLayoutConstraint.activate([
            productDetailsBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            productDetailsBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productDetailsBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productDetailsBottomView.heightAnchor.constraint(equalToConstant: 300)

        ])
    }
}

// MARK: - Create Data Source

extension ProductDetailsViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotSalesCell.reuseId, for: indexPath) as? HotSalesCell else { fatalError("Unable to dequeue cell")}
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
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
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



//MARK: - SwiftUI
import SwiftUI
struct ProductDetailsViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all).previewInterfaceOrientation(.portrait)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = UINavigationController(rootViewController: ProductDetailsViewController())
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }

        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
}
