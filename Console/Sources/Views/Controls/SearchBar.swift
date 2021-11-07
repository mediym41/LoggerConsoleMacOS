//
//  SearchBar.swift
//  Console
//
//  Created by Дмитрий Пащенко on 03.11.2021.
//

import SwiftUI

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

struct SearchBar: View {
    @Binding var text: String

    @State private var isEditing = false {
        didSet {
            print(isEditing)
        }
    }
        
    var body: some View {
        HStack {
            TextField("", text: $text)
                .padding(.vertical, 5)
                .padding(.trailing, 25)
                .padding(.leading, 30)
                .textFieldStyle(PlainTextFieldStyle())
                .background(Palette.main)
                .font(.circe(.regular, size: 14))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Palette.icons)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   alignment: .leading)
                            .padding(.bottom, 2)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                                
                            }) {
                                Image(systemName: "multiply.circle")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(Palette.icons)
                        }
                    }
                    .padding(.horizontal, 8)
                )
//                .onTapGesture {
//                    print("TEST")
//                    self.isEditing = true
//                }
                .onChange(of: text, perform: { _ in
                    
                })
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("Test and a lot of words with letters"))
    }
}
