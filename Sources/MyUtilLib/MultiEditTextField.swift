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
    let onSubmit: (String) -> Void
    let onChange: (String) -> Void

    private var isMultiple: Bool {
        text == multiValuesText
    }

    @FocusState private var isFocused: Bool
    @State private var localText: String

    public init (
        text: String,
        multiValuesText: String,
        alignment: Alignment = .trailing,
        textAlignment: TextAlignment = .trailing,
        foregroundStyle: AnyShapeStyle = AnyShapeStyle (.secondary),
        editForegroundStyle: AnyShapeStyle = AnyShapeStyle (.primary),
        keyboardType: UIKeyboardType = .default,
        onSubmit: @escaping (String) -> Void,
        onChange: @escaping (String) -> Void
    ) {
        self.text = text
        self.multiValuesText = multiValuesText
        self.alignment = alignment
        self.textAlignment = textAlignment
        self.foregroundStyle = foregroundStyle
        self.editForegroundStyle = editForegroundStyle
        self.keyboardType = keyboardType
        self.onSubmit = onSubmit
        self.onChange = onChange

        let isMultiple = text == multiValuesText
        self._localText = State (initialValue: isMultiple ? "" : text)
    }

    public var body: some View {
        TextField (isMultiple ? multiValuesText : "", text: $localText)
            .focused ($isFocused)
            .keyboardType (keyboardType)
            .multilineTextAlignment (textAlignment)
            .foregroundStyle (isFocused ? editForegroundStyle : foregroundStyle)
            .onSubmit { onSubmit (localText) }
            .onChange (of: localText) { newValue in
                onChange (newValue)
            }
    }
} // MultiEditTextField
