//
//  CartTableViewController.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import UIKit

class CartTableViewController: UIViewController {
    
    var cartItems = [CartCellViewModel]()
   // var bottomCartViewModel : CartBottomViewModelProtocol!
    
    var tableView: UITableView!
    
    var viewModel: CartTableViewModelProtocol!
    let bottomCartView = CartBottomView()



    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        self.tableView.dataSource = self
        tableView.delegate = self

        viewModel = CartTableViewModel()
        viewModel.fetchDataCallback = { [unowned self] viewModel in
            self.cartItems = viewModel.cartItems
            DispatchQueue.main.async {
              
                self.tableView.reloadData()
                self.bottomCartView.configure(with: viewModel.bottomCartViewModel)
            }
           
        }
        
        viewModel.countChangeCallback = {[unowned self] totalString in
            self.bottomCartView.configureTotalPrice(with: totalString)
        }
        
        setConstraints()
        tableView.register(CartTVCell.self, forCellReuseIdentifier: CartTVCell.reuseId)
    }
    
    private func setConstraints() {
        bottomCartView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomCartView)
        NSLayoutConstraint.activate([

            bottomCartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           // bottomCartView.heightAnchor.constraint(equalToConstant: 216),
            bottomCartView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }

    
}

extension CartTableViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTVCell.reuseId, for: indexPath) as! CartTVCell
        let cellItem = cartItems[indexPath.row]
        cell.delegate = self
        cell.configure(with: cellItem)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}

extension CartTableViewController: CartTVCellDelegate {
    func countChanged(_ cell: UITableViewCell, count: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        viewModel.countChanged(indexOfItem: indexPath.row, count: count)
        
    }

}


//MARK: - SwiftUI
import SwiftUI
struct CartTableViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = CartTableViewController()
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }

        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
}

