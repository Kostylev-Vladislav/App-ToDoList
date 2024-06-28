//
//  KeyboardAdaptiveModifire.swift
//  App_ToDoList
//
//  Created by Владислав on 29.06.2024.
//

import SwiftUI
import Combine

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    @Binding var isEditing: Bool

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.keyboardHeight)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            withAnimation {
                                self.keyboardHeight = keyboardFrame.height - geometry.safeAreaInsets.bottom
                            }
                        }
                    }
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        withAnimation {
                            self.keyboardHeight = 0
                        }
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self)
                }
        }
    }
}

extension View {
    func keyboardAdaptive(isEditing: Binding<Bool>) -> some View {
        self.modifier(KeyboardAdaptive(isEditing: isEditing))
    }
}
