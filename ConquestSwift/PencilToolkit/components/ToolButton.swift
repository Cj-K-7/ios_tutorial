//
//  IconButton.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/23/24.
//

import Foundation
import SwiftUI

struct ToolButton: View {
    var tool: Tool

    var selectedTool: Tool?
    var isSelected: Bool {
        selectedTool == tool
    }

    var suffix: String {
        isSelected
            ? "solid"
            : "line"
    }

    var onToolPress: (Tool) -> Void

    init(_ tool: Tool, selectedTool: Tool? = nil, onToolPress: @escaping (Tool) -> Void) {
        self.tool = tool
        self.selectedTool = selectedTool
        self.onToolPress = onToolPress
    }

    var body: some View {
        Button(
            action: { onToolPress(tool) }
        ) {
            Image("\(tool.icon.rawValue)-\(suffix)")
                .resizable()
                .foregroundStyle(.cyan)
        }
        .frame(width: 18, height: 18)
        .padding(.all, 4)
        .background(
            isSelected
                ? Color(hex: "#EEEEEE")
                : Color.clear
        )
        .cornerRadius(4)
    }
}

#if DEBUG
struct ToolkitIconButton_Preview: PreviewProvider {
    static var previews: some View {
        ToolButton(.pencil, selectedTool: .eraser) { tool in
            print(tool)
        }
    }
}
#endif

extension Notification.Name {
    static let toolButton = Notification.Name("ToolButton")
}
