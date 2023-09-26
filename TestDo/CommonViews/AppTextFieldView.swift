//
//  AppTextFieldView.swift
//  TestDo
//
//  Created by Keshu Rai on 25/09/23.
//

import Foundation
import SwiftUI

struct AppTextFieldView: View {
    @Binding var text : String 

    let placeholder = "Enter your text here" 

    var body: some View {
        ZStack(alignment: .topLeading) {

            TextEditor(text: $text)
                .padding(8)
                .frame(minHeight: 100, maxHeight: .infinity)
                .border(Color.gray.opacity(0.5), width: 1)
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(UIColor.placeholderText))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 14)
            }

        }
    }
}
