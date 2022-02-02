//
//  NSFont+Traits.swift
//  MarkdownKit
//
//  Created by Bruno Oliveira on 31/01/2019.
//  Copyright © 2019 Ivan Bruel. All rights reserved.
//
#if canImport(AppKit) && !targetEnvironment(macCatalyst)

    import AppKit

    public extension MarkdownFont {
        func italic() -> MarkdownFont {
            NSFontManager().convert(self, toHaveTrait: NSFontTraitMask.italicFontMask)
        }

        func bold() -> MarkdownFont {
            NSFontManager().convert(self, toHaveTrait: NSFontTraitMask.boldFontMask)
        }

        func isItalic() -> Bool {
            NSFontManager().traits(of: self).contains(.italicFontMask)
        }

        func isBold() -> Bool {
            NSFontManager().traits(of: self).contains(.boldFontMask)
        }

        func withSize(_ size: CGFloat) -> NSFont {
            NSFontManager().convert(self, toSize: size)
        }
    }

#endif
