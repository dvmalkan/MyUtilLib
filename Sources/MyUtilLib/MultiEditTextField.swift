//
//  MultiEditTextField.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/16/26.
//

import SwiftUI
import UIKit

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct MultiEditTextField: View {
    let text: String
    let multiValuesText: String
    let alignment: Alignment
    let textAlignment: TextAlignment
    let foregroundStyle: AnyShapeStyle
    let editForegroundStyle: AnyShapeStyle
    let keyboardType: UIKeyboardType
    let onCommit: (String) -> Void

    private var isMultiple: Bool {
        text == multiValuesText
    }

    @FocusState private var isFocused: Bool
    @State private var localText: String
    @State private var hasEdited = false

    public init (
        text: String,
        multiValuesText: String,
        alignment: Alignment = .trailing,
        textAlignment: TextAlignment = .trailing,
        foregroundStyle: AnyShapeStyle = AnyShapeStyle(.secondary),
        editForegroundStyle: AnyShapeStyle = AnyShapeStyle(.primary),
        keyboardType: UIKeyboardType = .default,
        onCommit: @escaping (String) -> Void
    ) {
        self.text = text
        self.multiValuesText = multiValuesText
        self.alignment = alignment
        self.textAlignment = textAlignment
        self.foregroundStyle = foregroundStyle
        self.editForegroundStyle = editForegroundStyle
        self.keyboardType = keyboardType
        self.onCommit = onCommit

        let isMultiple = text == multiValuesText
        self._localText = State (initialValue: isMultiple ? "" : text)
    }

    public var body: some View {
        TextField (isMultiple ? multiValuesText : "", text: $localText)
            .focused ($isFocused)
            .keyboardType (keyboardType)
            .multilineTextAlignment (textAlignment)
            .foregroundStyle (isFocused ? editForegroundStyle : foregroundStyle)
            .onChange(of: isFocused) { focused in
                if focused {
                    hasEdited = false
                } else {
                    commitIfNeeded ()
                }
            }
            .onChange (of: localText) { _ in
                if isFocused {
                    hasEdited = true
                }
            }
            .onChange (of: text) { newText in
                if !isFocused {
                    localText = newText == multiValuesText ? "" : newText
                    hasEdited = false
                }
            }
    }

    private func commitIfNeeded () {
        guard hasEdited else {
            return
        }

        onCommit (localText)

        hasEdited = false
    }
}
