//
//  PathComponentTableView.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import UIKit

class PathComponentTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(PathComponentTableViewCell.self, forCellReuseIdentifier: PathComponentTableViewCell.reuseIdentifier)
        rowHeight = PathComponentTableViewCell.cellHeight
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
}
