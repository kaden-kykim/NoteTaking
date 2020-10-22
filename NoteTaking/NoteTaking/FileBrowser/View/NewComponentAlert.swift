//
//  NewComponentAlert.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import UIKit

class NewComponentAlert {
    
    private let handler: ((String) -> Void)?
    private let type: PathComponent.CType
    
    private let alertController: UIAlertController
    private var alertDefaultAction: UIAlertAction!
    
    private weak var parentView: UIViewController?
    
    private init(of type: PathComponent.CType, handler: ((String) -> Void)?) {
        self.type = type
        self.handler = handler
        alertController = UIAlertController(title: "New \(type.rawValue)",
                                            message: "Enter the \(type.rawValue) name to create",
                                            preferredStyle: .alert)
        alertDefaultAction = UIAlertAction(title: "Create", style: .default, handler: { _ in
            if let name = self.alertController.textFields?.first?.text, let handler = handler {
                handler(name.trimmingCharacters(in: .whitespaces))
            }
        })
        alertDefaultAction.isEnabled = false
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alertController.addAction(alertDefaultAction)
        alertController.addTextField {
            $0.placeholder = "\(self.type.rawValue) Name"
            $0.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
            $0.returnKeyType = .done
        }
    }
    
    static func create(of type: PathComponent.CType, handler: ((String) -> Void)?) -> NewComponentAlert {
        let instance = NewComponentAlert(of: type, handler: handler)
        return instance
    }
    
    func present(on view: UIViewController?) {
        self.parentView = view
        parentView?.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func textFieldChanged(_ sender: UITextField) {
        if let text = sender.text {
            alertDefaultAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
    
}
