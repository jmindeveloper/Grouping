//
//  EmailTextField.swift
//  Grouping
//
//  Created by J_Min on 2023/07/10.
//

import SwiftUI

struct EmailTextField: View {
    enum FieldType {
        case Email, Password, Default
    }
    
    @Binding var text: String
    private var placeHolder: String
    private var secureMode: Bool
    @State var fieldType: FieldType
    @State var fieldSecure: Bool = false
    private var caption: String
    private var showCaption: Bool = false
    
    private init(text: Binding<String>, placeHolder: String, secureMode: Bool, type: FieldType, caption: String, showCaption: Bool) {
        self._text = text
        self.placeHolder = placeHolder
        self.secureMode = secureMode
        self.showCaption = showCaption
        self._fieldType = State(initialValue: type)
        self.showCaption = showCaption
        self.caption = caption
    }
    
    init(text: Binding<String>, type: FieldType, caption: String) {
        self.init(text: text, placeHolder: "", secureMode: false, type: type, caption: caption, showCaption: false)
    }
    
    var body: some View {
        VStack {
            HStack {
                if fieldSecure {
                    SecureField(placeHolder, text: $text)
                        .font(.system(size: 20, weight: .semibold, design: .serif))
                        .keyboardType(fieldType == .Email ? .emailAddress : .default)
                } else {
                    TextField(placeHolder, text: $text)
                        .font(.system(size: 20, weight: .semibold, design: .serif))
                        .keyboardType(fieldType == .Email ? .emailAddress : .default)
                }
                
                if secureMode {
                    Button {
                        fieldSecure.toggle()
                    } label: {
                        Image(systemName: "eye.slash.fill")
                            .resizable()
                            .frame(width: 25, height: 20)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 40, height: 40)
                }
                
                Button {
                    text.removeAll()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
                .frame(width: 40, height: 40)
            }
            .padding(.trailing, 3)
            
            Rectangle()
                .fill()
                .frame(height: 1)
            
            if showCaption {
                Text(caption)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(.top, 3)
            }
        }
    }
    
    func placeHolder(_ text: String) -> EmailTextField {
        EmailTextField(text: $text, placeHolder: text, secureMode: secureMode, type: fieldType, caption: caption, showCaption: showCaption)
    }
    
    func secureMode(_ enable: Bool) -> EmailTextField {
        EmailTextField(text: $text, placeHolder: placeHolder, secureMode: enable, type: fieldType, caption: caption, showCaption: showCaption)
    }
    
    func caption(_ show: Bool) -> EmailTextField {
        EmailTextField(text: $text, placeHolder: placeHolder, secureMode: secureMode, type: fieldType, caption: caption, showCaption: show)
    }
}

struct EmailTextField_Previews: PreviewProvider {
    @State static var text: String = ""
    
    static var previews: some View {
        EmailTextField(text: EmailTextField_Previews.$text, type: .Email, caption: "dkdkd")
            .placeHolder("이메일을 입력하세요")
            .padding(.horizontal, 16)
    }
}
