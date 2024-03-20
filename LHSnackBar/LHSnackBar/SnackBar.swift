//
//  SnackBar.swift
//  LHSnackBar
//
//  Created by Liam on 2024/3/14.
//

import SwiftUI

public struct SnackModel {
    
    public enum SnackType {
        case network
        
        var icon: String {
            switch self {
            case .network: "wifi.exclamationmark"
            }
        }
    }
    
    let snackType: SnackType
    let message: String
}

@available(iOS 15.0, *)
struct SnackBarModifier: ViewModifier {
    
    @Binding var model: SnackModel?
    
    init(model: Binding<SnackModel?>) {
        _model = model
    }
    
    public func body(content: Content) -> some View {
        content.overlay {
            VStack {
                if model != nil {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: model?.snackType.icon ?? "")
                                .frame(width: 44, height: 44, alignment: .leading)
                                .foregroundStyle(.white)
                            
                            Text(model?.message ?? "")
                                .font(Font.callout)
                                .padding(.leading, -16)
                                .foregroundColor(Color.white)
                                .lineLimit(1)
                            
                            Spacer()
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    }
                    .padding()
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                    .onTapGesture {
                        withAnimation {
                            model = nil
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                withAnimation {
                                    model = nil
                                }
                            }
                    )
                    .animation(.easeInOut)
                }
            }
        }
    }
}

@available(iOS 15.0, *)
struct TestSnackModifier: View {
    @State var model: SnackModel?
    var body: some View {
        VStack {
            Button("Test") { model = SnackModel(snackType: .network, message: "No network connection") }
            Button("Reset") { model = nil }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .modifier(SnackBarModifier(model: $model))
    }
}

@available(iOS 15.0, *)
struct SnackBar_Previews: PreviewProvider {
    static var previews: some View {
        TestSnackModifier()
    }
}

