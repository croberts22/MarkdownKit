//
//  MarkdownElement.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//
import Foundation

// MARK: - MarkdownElement

/// The base protocol for all Markdown Elements, it handles parsing through regex.
public protocol MarkdownElement: AnyObject {

    var regex: String { get }

    func regularExpression() throws -> NSRegularExpression
    func parse(_ attributedString: NSMutableAttributedString)
    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString)
}

public extension MarkdownElement {

    func parse(_ attributedString: NSMutableAttributedString) {
        var location = 0
        do {
            let regex = try regularExpression()
            while let regexMatch =
                regex.firstMatch(in: attributedString.string,
                                 options: .withoutAnchoringBounds,
                                 range: NSRange(location: location,
                                                length: attributedString.length - location)) {
                let oldLength = attributedString.length
                match(regexMatch, attributedString: attributedString)
                let newLength = attributedString.length
                location = regexMatch.range.location + regexMatch.range.length + newLength - oldLength
            }
        } catch {}
    }
}
