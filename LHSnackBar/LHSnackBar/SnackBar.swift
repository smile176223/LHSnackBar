//
//  SnackBar.swift
//  LHSnackBar
//
//  Created by Liam on 2024/3/14.
//

import SwiftUI

struct SnackBar: View {
    
    let text: String
    let action: () -> Void
    
    init(text: String, action: @escaping () -> Void = {}) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            
            Image(systemName: "network")
                .padding(.leading, 16)
                .foregroundStyle(.white)
            
            Text(text)
                .padding(.top, 15)
                .padding(.bottom, 15)
                .padding(.leading, 8)
                .font(Font.callout)
                .foregroundColor(Color.white)
            
            Spacer()
            
        }
        .lineLimit(1)
        .background(RoundedRectangle(cornerRadius: 5).fill(Color.black.opacity(0.8)))
        .frame(width: UIScreen.main.bounds.width - 32, height: 44, alignment: .leading)
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    SnackBar(text: "No internet connection.")
}
