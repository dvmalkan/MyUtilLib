//
//  MultiEditTextField.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/16/26.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct MultiEditTextField: View {
    let text: String
    let multiValuesText: String
    let alignment: Alignment
    let textAlignment: TextAlignment
    let foregroundStyle: AnyShapeStyle
#if os(iOS)
    let keyboardType: UIKeyboardType
#endif
    let onSubmit: (String) -> Void
    let onChange: (String) -> Void
    
    private var isMultiple: Bool {
        text == multiValuesText
    }
    
    @FocusState private var isFocused: Bool
    @State private var localText: String
    
#if os(iOS)
    public init (
        text: String,
        multiValuesText: String,
        alignment: Alignment = .trailing,
        textAlignment: TextAlignment = .trailing,
        foregroundStyle: AnyShapeStyle = AnyShapeStyle (.primary),
        keyboardType: UIKeyboardType = .default,
        onSubmit: @escaping (String) -> Void,
        onChange: @escaping (String) -> Void
    ) {
        self.text = text
        self.multiValuesText = multiValuesText
        self.alignment = alignment
        self.textAlignment = textAlignment
        self.foregroundStyle = foregroundStyle
        self.keyboardType = keyboardType
        self.onSubmit = onSubmit
        self.onChange = onChange
        
        let isMultiple = text == multiValuesText
        self._localText = State (initialValue: isMultiple ? "" : text)
    }
#else
    public init (
        text: String,
        multiValuesText: String,
        alignment: Alignment = .trailing,
        textAlignment: TextAlignment = .trailing,
        foregroundStyle: AnyShapeStyle = AnyShapeStyle (.primary),
        onSubmit: @escaping (String) -> Void,
        onChange: @escaping (String) -> Void
    ) {
        self.text = text
        self.multiValuesText = multiValuesText
        self.alignment = alignment
        self.textAlignment = textAlignment
        self.foregroundStyle = foregroundStyle
        self.onSubmit = onSubmit
        self.onChange = onChange
        
        let isMultiple = text == multiValuesText
        self._localText = State (initialValue: isMultiple ? "" : text)
    }
#endif

    public var body: some View {
        HStack {
            TextField (isMultiple ? multiValuesText : "", text: $localText)
                .focused ($isFocused)
#if os(iOS)
                .keyboardType (keyboardType)
#endif
                .multilineTextAlignment (textAlignment)
                .foregroundStyle (foregroundStyle)
                .onSubmit { onSubmit (localText) }
                .onChange (of: localText) { newValue in
                    onChange (newValue)
                }
            if isFocused {
                    Button {
                        isFocused = false
                    } label: {
                        Image (systemName: "xmark.circle.fill")
                    }
                }
        }
    }
} // MultiEditTextField
