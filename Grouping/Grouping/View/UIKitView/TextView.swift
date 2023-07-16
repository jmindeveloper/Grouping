//
//  TextView.swift
//  Grouping
//
//  Created by J_Min on 2023/07/16.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    var placeHolder: String?
    private var font: UIFont = UIFont()
    
    init(text: Binding<String>, placeHolder: String? = nil, font: UIFont = UIFont()) {
        self._text = text
        self.placeHolder = placeHolder
        self.font = font
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        if let placeHolder = placeHolder {
            textView.text = placeHolder
            textView.textColor = .systemGray6
        } else {
            textView.textColor = .label
        }
        
        textView.delegate = context.coordinator
        textView.font = font
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
    }
    
    func makeCoordinator() -> TextViewCoordinator {
        return TextViewCoordinator(parent: self)
    }
    
    func font(_ uiFont: UIFont) -> TextView {
        TextView(text: $text, placeHolder: placeHolder, font: uiFont)
    }
}

public class TextViewCoordinator: NSObject, UITextViewDelegate {
    var parent: TextView
    
    init(parent: TextView) {
        self.parent = parent
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        parent.text = textView.text
        
        if textView.text.isEmpty {
            textView.textColor = .systemGray6
        } else {
            textView.textColor = .label
        }
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == parent.placeHolder {
            textView.text = ""
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = parent.placeHolder
        }
    }
}
