//
//  MarkdownLink.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//
import Foundation

open class MarkdownLink: MarkdownLinkElement {

    fileprivate static let regex = "(\\[[^\\]]+\\])(\\([^\\s]+)?\\)"

    private let schemeRegex = "([a-z]{2,20}):\\/\\/"

    open var font: MarkdownFont?
    open var color: MarkdownColor?
    open var defaultScheme: String?

    open var regex: String {
        MarkdownLink.regex
    }

    open func regularExpression() throws -> NSRegularExpression {
        try NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
    }

    public init(font: MarkdownFont? = nil, color: MarkdownColor? = MarkdownLink.defaultColor) {
        self.font = font
        self.color = color
    }

    open func formatText(_ attributedString: NSMutableAttributedString, range: NSRange, link: String) {
        let regex = try? NSRegularExpression(pattern: schemeRegex, options: .caseInsensitive)
        let hasScheme = regex?.firstMatch(
            in: link,
            options: .anchored,
            range: NSRange(0 ..< link.count)
        ) != nil

        let fullLink = hasScheme ? link : "\(defaultScheme ?? "https://")\(link)"

        guard let encodedLink = fullLink.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: fullLink) ?? URL(string: encodedLink) else { return }
        attributedString.addAttribute(NSAttributedString.Key.link, value: url, range: range)
    }

    open func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {

        let firstMatch = match.range(at: 1)
        // Remove opening bracket
        attributedString.deleteCharacters(in: NSRange(location: firstMatch.location, length: 1))

        // Remove closing bracket
        attributedString.deleteCharacters(in: NSRange(location: firstMatch.location + (firstMatch.length - 2), length: 1))

        let urlStart = match.range(at: 2).location - 1

        let string = NSString(string: attributedString.string)
        var urlString = String(string.substring(with: NSRange(urlStart ..< match.range(at: 2).upperBound - 2)))

        // Balance opening and closing parentheses inside the url
        var numberOfOpeningParentheses = 0
        var numberOfClosingParentheses = 0
        for (index, character) in urlString.enumerated() {
            switch character {
            case "(": numberOfOpeningParentheses += 1
            case ")": numberOfClosingParentheses += 1
            default: continue
            }
            if numberOfClosingParentheses > numberOfOpeningParentheses {
                urlString = NSString(string: urlString).substring(with: NSRange(0 ..< index))
                break
            }
        }

        // Remove opening parentheses
        attributedString.deleteCharacters(in: NSRange(location: match.range(at: 2).location - 2, length: 1))

        // Remove closing parentheses
        let trailingMarkdownRange = NSRange(location: match.range(at: 2).location - 2, length: urlString.count + 1)
        attributedString.deleteCharacters(in: trailingMarkdownRange)

        let formatRange = NSRange(match.range(at: 1).location ..< match.range(at: 2).location - 2)

        // Add attributes while preserving current attributes

        let currentAttributes = attributedString.attributes(
            at: formatRange.location,
            longestEffectiveRange: nil,
            in: formatRange
        )

        addAttributes(attributedString, range: formatRange)
        formatText(attributedString, range: formatRange, link: urlString)

        if let font = currentAttributes[.font] as? MarkdownFont {
            attributedString.addAttribute(
                NSAttributedString.Key.font,
                value: font,
                range: formatRange
            )
        }
    }

    open func addAttributes(_ attributedString: NSMutableAttributedString, range: NSRange) {
        attributedString.addAttributes(attributes, range: range)
    }
}
