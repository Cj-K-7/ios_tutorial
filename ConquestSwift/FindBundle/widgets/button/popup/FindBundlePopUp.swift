//
//  CropPopUp.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/21/24.
//

import SwiftUI
import UIKit

struct CropPopUp: View {
    var onAIFindPress: () -> Void
    var onManualFindPress: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("문항 찾기")
                .font(Font.system(size: 18, weight: .bold))

            VStack(alignment: .leading, spacing: 16) {
                Text("문항을 찾고 태그를 적용하면 [내 문제은행]에 쌓여요.\n자동 또는 수동으로 문항 찾기 후 태그를 추가해 주세요!")
                    .font(Font.system(size: 14))
                    .foregroundColor(Color(hex: "#616161"))
                ArticleButton(
                    title: "🤖 AI 문항 찾기",
                    description: "쏠브AI가 문항을 한번에 찾아줘요.",
                    onPress: self.onAIFindPress
                )
                ArticleButton(
                    title: "✍🏻 수동 문항 찾기",
                    description: "내가 원하는 문항만 골라서 찾아요.",
                    onPress: self.onManualFindPress
                )
            }
        }
        .frame(maxWidth: 312)
        .padding(.all, 24)
        .background(Color.white)
        .cornerRadius(8.0)
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 0)
        .shadow(color: Color.black.opacity(0.1), radius: 8)
    }
}

#if DEBUG

struct CropPopUp_Previews: PreviewProvider {
    static var previews: some View {
        CropPopUp(onAIFindPress: { print("🤖 AI!") }, onManualFindPress: { print("MANUAL!") })
    }
}

#endif
