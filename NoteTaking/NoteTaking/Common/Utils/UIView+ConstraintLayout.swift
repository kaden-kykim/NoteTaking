//
//  UIView+ConstraintLayout.swift
//  NoteTaking
//
//  Created by Derrick Park on 2019-04-29.
//  Modified by Kaden Kim on 2020-10-21.
//

import UIKit

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIView {
    
    @discardableResult
    func matchParent(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        if let superTopAnchor = superview?.topAnchor {
            anchoredConstraints.top = self.topAnchor.constraint(equalTo: superTopAnchor, constant: padding.top)
        }
        if let superBottomAnchor = superview?.bottomAnchor {
            anchoredConstraints.bottom = self.bottomAnchor.constraint(equalTo: superBottomAnchor, constant: -padding.bottom)
        }
        if let superLeadingAnchor = superview?.leadingAnchor {
            anchoredConstraints.leading = self.leadingAnchor.constraint(equalTo: superLeadingAnchor, constant: padding.left)
        }
        if let superTrailingAnchor = superview?.trailingAnchor {
            anchoredConstraints.trailing = self.trailingAnchor.constraint(equalTo: superTrailingAnchor, constant: -padding.right)
        }
        activeAnchoredConstraints(anchoredConstraints)
        return anchoredConstraints
    }
    
    @discardableResult
    func anchors(topAnchor: NSLayoutYAxisAnchor?, leadingAnchor: NSLayoutXAxisAnchor?, trailingAnchor: NSLayoutXAxisAnchor?, bottomAnchor: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        if let topAnchor = topAnchor {
            anchoredConstraints.top = self.topAnchor.constraint(equalTo: topAnchor, constant: padding.top)
        }
        if let bottomAnchor = bottomAnchor {
            anchoredConstraints.bottom = self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)
        }
        if let leadingAnchor = leadingAnchor {
            anchoredConstraints.leading = self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left)
        }
        if let trailingAnchor = trailingAnchor {
            anchoredConstraints.trailing = self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right)
        }
        if size.width != 0 {
            anchoredConstraints.width = self.widthAnchor.constraint(equalToConstant: size.width)
        }
        if size.height != 0 {
            anchoredConstraints.height = self.heightAnchor.constraint(equalToConstant: size.height)
        }
        activeAnchoredConstraints(anchoredConstraints)
        return anchoredConstraints
    }
    
    @discardableResult
    func constraintWidth(equalToConstant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.width = self.widthAnchor.constraint(equalToConstant: equalToConstant)
        anchoredConstraints.width!.isActive = true
        return anchoredConstraints
    }
    
    @discardableResult
    func constraintHeight(equalToConstant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.height = self.heightAnchor.constraint(equalToConstant: equalToConstant)
        anchoredConstraints.height!.isActive = true
        return anchoredConstraints
    }
    
    @discardableResult
    func constraintWidth(equalToConstant: CGFloat, heightEqualToConstant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.width = self.widthAnchor.constraint(equalToConstant: equalToConstant)
        anchoredConstraints.height = self.heightAnchor.constraint(equalToConstant: heightEqualToConstant)
        activeAnchoredConstraints(anchoredConstraints)
        return anchoredConstraints
    }
    
    @discardableResult
    func matchSize() -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        if let superWidthAnchor = superview?.widthAnchor {
            anchoredConstraints.width = self.widthAnchor.constraint(equalTo: superWidthAnchor)
        }
        if let superHeightAnchor = superview?.heightAnchor {
            anchoredConstraints.height = self.heightAnchor.constraint(equalTo: superHeightAnchor)
        }
        activeAnchoredConstraints(anchoredConstraints)
        return anchoredConstraints
    }
    
    func centerXYin(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func activeAnchoredConstraints(_ anchoredConstraints: AnchoredConstraints) {
        [anchoredConstraints.top,
         anchoredConstraints.bottom,
         anchoredConstraints.leading,
         anchoredConstraints.trailing,
         anchoredConstraints.width,
         anchoredConstraints.height
        ].forEach { $0?.isActive = true }
    }
    
}
