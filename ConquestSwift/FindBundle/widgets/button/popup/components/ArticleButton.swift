//
//  ColumButton.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/21/24.
//

import SwiftUI

struct ArticleButton: View {
    @State var isSelected: Bool = false
    var title: String = "Title"
    var description: String = "Description"
    var onPress: () -> Void = {}

    var body: some View {
        Button(
            action: {
                // action
            }
        ) {
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(title)
                    .font(Font.system(size: 18, weight: .bold))
                Text(description)
                    .font(Font.system(size: 14))
                    .foregroundColor(Color(hex: "#616161"))
            }
        }
        .buttonStyle(ArticleButtonStyle())
    }
}

struct ArticleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all, 18)
            .background(Color(hex: configuration.isPressed ? "#E9F1FF" : "#F5F5F5"))
            .cornerRadius(4.0)
            .overlay(
                configuration.isPressed ?
                    RoundedRectangle(cornerRadius: 4.0)
                    .stroke(Color(hex: "#27F"), lineWidth: 1.5) : nil
            )
    }
}

#if DEBUG

struct ArticleButton_Previews: PreviewProvider {
    static var previews: some View {
        ArticleButton()
    }
}

#endif
