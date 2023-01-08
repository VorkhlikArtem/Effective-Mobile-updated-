//
//  ViewController.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    var selectedCategory = 0
    
    var collectionView: UICollectionView!
    lazy var filterView = FilterView()
    let refreshControl = UIRefreshControl()
    lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.isUserInteractionEnabled = false
        return visualEffectView
    }()
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<MainViewModel.Section, MainViewModel.Item>
    
    var dataSource: DataSourceType!
    var model = MainModel()
    let dataFetcher = DataFetcher()
    
    var hotSalesFooter: PageControlFooter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        dataSource = createDataSource()
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        setupRefreshControl()
        
        model.selectCategoryImageNames = CategoryItem.categorySectionModel
        self.reloadData()
        getData()
    }
    
//    private func getData() {
//        dataFetcher.getMain { [weak self] mainResponse in
//            guard let self = self else {return}
//            guard let mainResponse = mainResponse else { self.refreshControl.endRefreshing()
//                return}
//            self.model.hotSalesItem = mainResponse.homeStore
//            self.model.bestSellerItem = mainResponse.bestSeller
//            DispatchQueue.main.async {
//                self.reloadData()
//                let numberOfItems = self.dataSource.snapshot().numberOfItems(inSection: .hotSalesSection)
//                self.hotSalesFooter?.configure(numberOfPages: numberOfItems)
//                self.refreshControl.endRefreshing()
//            }
//        }
//    }
    
    var cancellables: Set<AnyCancellable> = []
    
    private func getData() {
        dataFetcher.getMain1()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.refreshControl.endRefreshing()
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] mainResponse in
                guard let self = self else {return}
                self.model.hotSalesItem = mainResponse.homeStore
                self.model.bestSellerItem = mainResponse.bestSeller
                self.reloadData()
                
                let numberOfItems = self.dataSource.snapshot().numberOfItems(inSection: .hotSalesSection)
                self.hotSalesFooter?.configure(numberOfPages: numberOfItems)
                self.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)

    }
    
    // MARK: - Setup Refresh Control
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateMain), for: .valueChanged)
    }
    
    @objc private func updateMain() {
       getData()
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
        
        collectionView.register(HeaderWithButton.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderWithButton.reuseId)
        collectionView.register(SelectCategoryCell.self, forCellWithReuseIdentifier: SelectCategoryCell.reuseId)
        collectionView.register(HotSalesCell.self, forCellWithReuseIdentifier: HotSalesCell.reuseId)
        collectionView.register(BestSellerCell.self, forCellWithReuseIdentifier: BestSellerCell.reuseId)
        collectionView.register(PageControlFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PageControlFooter.reuseId)
        
    }
    
  
    // MARK: - Reload Data
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<MainViewModel.Section, MainViewModel.Item>()
        snapShot.appendSections(MainViewModel.Section.allCases)
        
        let selectCategoryItems = model.selectCategoryImageNames.map {MainViewModel.Item.selectCategoryItem(category: $0) }
        snapShot.appendItems(selectCategoryItems, toSection: .selectCategorySection)
        
        let hotSalesItem = model.hotSalesItem.map {MainViewModel.Item.hotSalesItem(hotSalesItem: $0) }
        snapShot.appendItems(hotSalesItem, toSection: .hotSalesSection)

        let bestSellerItem = model.bestSellerItem.map {MainViewModel.Item.bestSellerItem(bestSellersItem: $0) }
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
                cell.configure(with: hotSalesItem)
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
            
            switch kind {
                
            case UICollectionView.elementKindSectionHeader:
                
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderWithButton.reuseId, for: indexPath) as? HeaderWithButton else {return nil}
                
                switch section {
                case .selectCategorySection:
                    sectionHeader.configure(title: section.rawValue, buttonText: "view all")

                default:
                    sectionHeader.configure(title: section.rawValue, buttonText: "see more")
                }
                return sectionHeader
                
            case UICollectionView.elementKindSectionFooter:
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                switch section {
                
                case .hotSalesSection:
                    guard let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PageControlFooter.reuseId, for: indexPath) as? PageControlFooter else {return nil}
                    self.hotSalesFooter = sectionFooter

                    return sectionFooter
               
                default:return nil
                }
                
            default: return nil
            }
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
        
        section.visibleItemsInvalidationHandler = { [weak self] (items, offset, env) -> Void in
            guard let self = self,
                  let itemWidth = items.last?.bounds.width else { return }
            let insets = (env.container.contentSize.width - itemWidth)
            let page = offset.x / (itemWidth + insets)
            self.didChangeCollectionViewPage(to: page)
        }
        
        let sectionHeader = createSectionHeaderLayout()
        sectionHeader.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
        
        let sectionFooter = createSectionFooterLayout()
        sectionFooter.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
        
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
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
    
    private func createSectionFooterLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionFooterSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        return sectionFooter
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
            print("hotSalesSection tapped")
        case .bestSellersSection:
            showNextVC()
            print("bestSellersSection tapped")
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

// MARK: - Best Seller Cell Delegate
extension MainViewController: BestSellerCellDelegate {
    func toggleIsFavoriteProperty(_ cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        model.bestSellerItem[indexPath.row].isFavorites.toggle()
        reloadData()
    }
}

// MARK: - Filter View Presenting and Dismissing
extension MainViewController: FilterViewDelegate {
    @objc func filterTapped() {
        filterView.delegate = self
        view.addSubviewWithWholeFilling(subview: visualEffectView)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        let topBarHeight = (navigationController?.navigationBar.frame.height ?? 0) + (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            filterView.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarHeight),
        ])
        
        NotificationCenter.default.post(name: .hideFilterTables, object: nil)
        animateAlertIn()
    }
    
    func animateAlertIn() {
        filterView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        filterView.alpha = 0
        visualEffectView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 0.8
            self.filterView.alpha = 1
            self.filterView.transform = .identity
        }
    }
    
    func animateAlertOut() {
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 0
            self.filterView.alpha = 0
            self.filterView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        } completion: { _ in
            self.filterView.removeFromSuperview()
        }
    }
    
    func removeViewFromSuperview(_ filterView: UIView) {
        animateAlertOut()
    }
}

// MARK: - Paging for Section Footers Handling
extension MainViewController {
    func didChangeCollectionViewPage (to page: CGFloat) {
       // print(page)
        hotSalesFooter?.changeCurrentPage(to: page)
    }

}
