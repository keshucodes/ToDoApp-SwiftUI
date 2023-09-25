//
//  AppButton.swift
//  TestDo
//
//  Created by Keshu Rai on 25/09/23.
//

import Foundation
import SwiftUI

struct AppButton: View {
    let title: String
    var bgColor : Color = .green

    let action: () -> Void

    var body: some View {
        
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(bgColor)
                .cornerRadius(10)
                .padding()
        }
    }
}
