//
//  UIFont+Traits.swift
//  Pods
//
//  Created by Ivan Bruel on 19/07/16.
//
//

#if canImport(UIKit)

    import UIKit

    extension UIFont {

        func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont? {
            guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) else {
                return nil
            }
            return UIFont(descriptor: descriptor, size: 0)
        }

        func bold() -> UIFont {
            withTraits(fontDescriptor.symbolicTraits, .traitBold) ?? self
        }

        func italic() -> UIFont {
            withTraits(fontDescriptor.symbolicTraits, .traitItalic) ?? self
        }

        func isItalic() -> Bool {
            fontDescriptor.symbolicTraits.contains(.traitItalic)
        }

        func isBold() -> Bool {
            fontDescriptor.symbolicTraits.contains(.traitBold)
        }
    }

#endif
