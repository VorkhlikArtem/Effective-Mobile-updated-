//
//  FilteringTableView.swift
//  EcommerceConcept
//
//  Created by Артём on 04.12.2022.
//

import UIKit

class FilteringTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        //reloadData()
    }
    
    convenience init(filteringOptions: [String]) {
        self.init(frame: .zero)
        self.backgroundColor = .gray
        
        self.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        reloadData()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func numberOfRows(inSection section: Int) -> Int {
        return 10
    }
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        let cell = self.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "55555"
        content.textProperties.color = .red
        cell.contentConfiguration = content
        return cell
    }
}
