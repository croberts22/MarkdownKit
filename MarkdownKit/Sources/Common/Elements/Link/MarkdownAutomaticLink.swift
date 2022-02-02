//
//  MarkdownAutomaticLink.swift
//  Pods
//
//  Created by Ivan Bruel on 19/07/16.
//
//
import Foundation

open class MarkdownAutomaticLink: MarkdownLink {

    override open func regularExpression() throws -> NSRegularExpression {
        try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    }

    override open func match(_ match: NSTextCheckingResult,
                             attributedString: NSMutableAttributedString) {
        let linkURLString = attributedString.attributedSubstring(from: match.range).string
        formatText(attributedString, range: match.range, link: linkURLString)
        addAttributes(attributedString, range: match.range)
    }
}
