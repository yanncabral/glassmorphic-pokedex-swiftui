//
//  BottomSheetView.swift
//  pokedex
//
//  Created by Yann Cabral on 05/02/21.
//

import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 30
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, minHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
        )
    }

    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
//            .background(Color(.secondarySystemBackground).opacity(0.7))
            .background(BlurView(style: .systemUltraThinMaterial))
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
    
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            Color.green
            BottomSheetView(
                isOpen: .constant(true),
                maxHeight: geometry.size.height * 0.7
            ) {
                Color.blue
            }
        }.edgesIgnoringSafeArea(.all)
    }
}
