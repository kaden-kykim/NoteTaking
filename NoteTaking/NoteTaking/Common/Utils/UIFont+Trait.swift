//
//  UIFont+Trait.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import UIKit

extension UIFont {
    
    func copyTraits(to font: UIFont) -> UIFont {
        var traits = fontDescriptor.symbolicTraits
        if traits.contains(.traitMonoSpace) { traits.remove(.traitMonoSpace) }
        if let newFontDescriptor = fontDescriptor.withFamily(font.familyName).withSymbolicTraits(traits) {
            return UIFont(descriptor: newFontDescriptor, size: font.pointSize)
        }
        return font
    }
    
    func toggleSemiBold() -> UIFont {
        if fontDescriptor.symbolicTraits.contains(.traitBold) {
            var traits = fontDescriptor.symbolicTraits
            traits.remove(.traitBold)
            if let newFontDescriptor = fontDescriptor.withSymbolicTraits(traits) {
                return UIFont(descriptor: newFontDescriptor, size: self.pointSize)
            }
        } else {
            var attributes = fontDescriptor.fontAttributes
            var traits = attributes[.traits] as? [UIFontDescriptor.TraitKey: Any] ?? [:]
            traits[.weight] = UIFont.Weight.semibold
            attributes[.traits] = traits
            return UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size: self.pointSize)
        }
        return UIFont(descriptor: self.fontDescriptor, size: self.pointSize)
    }
    
    func toggleItalic() -> UIFont {
        var traits = fontDescriptor.symbolicTraits
        if traits.contains(.traitItalic) { traits.remove(.traitItalic) }
        else { traits.insert(.traitItalic) }
        if let newFontDescriptor = fontDescriptor.withSymbolicTraits(traits) {
            return UIFont(descriptor: newFontDescriptor, size: self.pointSize)
        }
        return UIFont(descriptor: self.fontDescriptor, size: self.pointSize)
    }
    
}
