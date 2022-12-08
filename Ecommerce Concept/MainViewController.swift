//
//  ViewController.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import UIKit

class MainViewController: UIViewController {
    var selectedCategory = 0
    
    var collectionView: UICollectionView!
    lazy var filterView = FilterView()
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>

    enum ViewModel {
        enum Section: String, Hashable, CaseIterable {
            case selectCategorySection = "Select Category"
            case hotSalesSection = "Hot Sales"
            case bestSellersSection = "Best Seller"
        }
        enum Item : Hashable {
            case selectCategoryItem(category: Constants.CategorySection  )
            case hotSalesItem(hotSalesItem: HotSalesItem)
            case bestSellerItem(bestSellersItem: BestSellersItem)
            
            func hash(into hasher: inout Hasher) {
                switch self {
                
                case .selectCategoryItem(let category):
                    hasher.combine(category.title )
                case .hotSalesItem(let hotSalesItem):
                    hasher.combine(hotSalesItem.id)
                case .bestSellerItem(let bestSellersItem):
                    hasher.combine(bestSellersItem.id)
                }
            }
            
            static func == (lhs: Item, rhs: Item) -> Bool {
                switch (lhs, rhs) {
                case (.selectCategoryItem(let lCategory) , .selectCategoryItem(let rCategory)):
                    return lCategory.title == rCategory.title
                case (.hotSalesItem(let lHotSalesItem), .hotSalesItem(let rHotSalesItem) ):
                    return lHotSalesItem.id == rHotSalesItem.id
                case (.bestSellerItem(let lBestSellersItem), .bestSellerItem(let rBestSellersItem)):
                    return lBestSellersItem.id == rBestSellersItem.id
                default: return false
                }
            }
        }
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    let networkManager = NetworkManager()
    
    struct Model{
        var selectCategoryImageNames = [Constants.CategorySection]()
        var hotSalesItem = [HotSalesItem]()
        var bestSellerItem = [BestSellersItem]()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.allowsSelectionDuringEditing = true
        
        model.selectCategoryImageNames = Constants.categorySectionModel
        
        let mainResponse = Bundle.main.decode(MainResponse.self, from: "mainData.json")
        self.model.hotSalesItem = mainResponse.homeStore
        self.model.bestSellerItem = mainResponse.bestSeller

        self.reloadData()
        
        
//        networkManager.fetchData(url: NetworkManager.mainUrlSting) { [weak self] mainResponse in
//            guard let self = self else {return}
//            self.model.hotSalesItem = mainResponse.homeStore
//            self.model.bestSellerItem = mainResponse.bestSeller
//            DispatchQueue.main.async {
//                self.reloadData()
//            }
//        }
        
    }
    
    // MARK: -  NavigationBar & CollectionView setups
    private func setupNavigationBar() {
        let button = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain , target: self, action: #selector(filterTapped))
        button.tintColor = #colorLiteral(red: 0.00884380471, green: 0.02381574176, blue: 0.1850150228, alpha: 1)
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .backgroundColor
        view.addSubview(collectionView)
        
        collectionView.register(HeaderWithoutButton.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderWithoutButton.reuseId)
        collectionView.register(HeaderWithButton.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderWithButton.reuseId)
        collectionView.register(SelectCategoryCell.self, forCellWithReuseIdentifier: SelectCategoryCell.reuseId)
        collectionView.register(HotSalesCell.self, forCellWithReuseIdentifier: HotSalesCell.reuseId)
        collectionView.register(BestSellerCell.self, forCellWithReuseIdentifier: BestSellerCell.reuseId)
        
    }
    
    @objc func filterTapped() {
        print("filter")
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            filterView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
        ])
    }
    
    // MARK: - reloadData
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        snapShot.appendSections(ViewModel.Section.allCases)  // change
        
        let selectCategoryItems = model.selectCategoryImageNames.map {ViewModel.Item.selectCategoryItem(category: $0) }
        snapShot.appendItems(selectCategoryItems, toSection: .selectCategorySection)
        
        let hotSalesItem = model.hotSalesItem.map {ViewModel.Item.hotSalesItem(hotSalesItem: $0) }
        snapShot.appendItems(hotSalesItem, toSection: .hotSalesSection)

        let bestSellerItem = model.bestSellerItem.map {ViewModel.Item.bestSellerItem(bestSellersItem: $0) }
        snapShot.appendItems(bestSellerItem, toSection: .bestSellersSection)
        
        dataSource?.apply(snapShot, animatingDifferences: true)
        
    }
}

// MARK: - Create Data Source
extension MainViewController {
    func createDataSource()->DataSourceType{
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, item  in
            switch item {
            case .selectCategoryItem(let category) :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCategoryCell.reuseId, for: indexPath) as! SelectCategoryCell
                cell.configure(with: category)
                if indexPath.row == self.selectedCategory {
                   cell.select()
                }
                return cell
                
            case .hotSalesItem(let hotSalesItem) :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotSalesCell.reuseId, for: indexPath) as! HotSalesCell
                cell.configure(with: hotSalesItem.picture)
                return cell
                
            case .bestSellerItem(let bestSellersItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BestSellerCell.reuseId, for: indexPath) as! BestSellerCell
                cell.delegate = self
                cell.configure(with: bestSellersItem)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderWithButton.reuseId, for: indexPath) as? HeaderWithButton else {return nil}
            
            switch section {
            case .selectCategorySection:
                sectionHeader.configure(title: section.rawValue, buttonText: "view all")
            default:
                sectionHeader.configure(title: section.rawValue, buttonText: "see more")
            }
            return sectionHeader
        }
        return dataSource
    }
}

// MARK: - Create Compositional Layout
extension MainViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {  sectionIndex, layoutEnvironment in
            
            switch self.dataSource.snapshot().sectionIdentifiers[sectionIndex] {
            case .selectCategorySection :
                return self.createSelectCategorySectionLayout()
            case .hotSalesSection :
                return self.createHotSalesSectionLayout()
            case .bestSellersSection:
                return self.createBestSellersSectionLayout()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createSelectCategorySectionLayout() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupWidth = Constants.selectCategoryCellWidth
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .estimated(groupWidth + 50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 23
        section.contentInsets = .init(top: 16, leading: 27, bottom: 0, trailing: 27)
        
        let sectionHeader = createSectionHeaderLayout()
        section.boundarySupplementaryItems = [sectionHeader]
      
        return section
    }
    
    private func createHotSalesSectionLayout()-> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
       
        let section = NSCollectionLayoutSection(group: group)
        //section.interGroupSpacing = 10
        section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let sectionHeader = createSectionHeaderLayout()
        sectionHeader.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createBestSellersSectionLayout()-> NSCollectionLayoutSection? {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(Constants.bestSellersGroupAspectRatio) )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(14)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 14, bottom: 14, trailing: 14)
        section.interGroupSpacing = 12
       
        
        let sectionHeader = createSectionHeaderLayout()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return sectionHeader
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let section = dataSource.sectionIdentifier(for: indexPath.section) else {return}
        
        switch section {
        case .selectCategorySection:
            if let cell = collectionView.cellForItem(at: IndexPath(row: selectedCategory, section: 0 )) as? SelectCategoryCell   {
                cell.deselect()
            }
            selectedCategory = indexPath.row
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? SelectCategoryCell else {return}
            cell.select()
        case .hotSalesSection:
            print("hotSalesSection")
        case .bestSellersSection:
            showNextVC()
            print("bestSellersSection")
        }
    }
    
}

// MARK: - Routing
extension MainViewController {
    private func showNextVC() {
        let productDetailVC = ProductDetailsViewController()
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

// MARK: - BestSellerCellDelegate

extension MainViewController: BestSellerCellDelegate {
    func toggleIsFavoriteProperty(_ cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        model.bestSellerItem[indexPath.row].isFavorites.toggle()
        reloadData()
    }
}




//MARK: - SwiftUI
import SwiftUI
struct MainViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all).previewInterfaceOrientation(.portrait)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = MainViewController()
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }

        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
}
