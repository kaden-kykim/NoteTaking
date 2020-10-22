//
//  PathComponentTableViewCell.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import UIKit

class PathComponentTableViewCell: UITableViewCell {
    
    static let cellHeight: CGFloat = 50
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    func setPathComponent(_ pathComponent: PathComponent) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        textLabel?.text = pathComponent.name
        switch pathComponent.type {
        case .directory:
            detailTextLabel?.text = "\(dateFormatter.string(from: pathComponent.date)) - \(Int(pathComponent.extraInfo)) Item(s)"
            imageView?.image = UIImage(systemName: "folder")
            accessoryType = .disclosureIndicator
        case .note:
            detailTextLabel?.text = dateFormatter.string(from: pathComponent.date)
            imageView?.image = UIImage(systemName: "doc.richtext")
            accessoryType = .none
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
}
