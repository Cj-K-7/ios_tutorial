//
//  CropButton.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/22/24.
//

import SwiftUI

struct CropButton: View {
    @State var isPressed = false

    var title: String
    var onPress: () -> Void

    var body: some View {
        Button(action: { isPressed.toggle() }) {
            Image(
                isPressed
                    ? "icon-bundle-definition-solid"
                    : "icon-bundle-definition-line"
            )
            .resizable()
        }
        .buttonStyle(CropButtonStyle())
        .background(isPressed ? Color(hex: "#EEEEEE") : Color.clear)
        .popover(isPresented: $isPressed, content: {
            CropPopUp {} onManualFindPress: {}

        })
    }
}

struct CropButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 18, height: 18)
            .padding(.all, 4)
            .cornerRadius(4.0)
    }
}

#if DEBUG

struct CropButton_Previews: PreviewProvider {
    static var previews: some View {
        CropButton(title: "🤖 AI 문항 찾기", onPress: { print("🤖 AI!") })
    }
}

#endif
