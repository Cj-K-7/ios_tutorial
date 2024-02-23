//
//  ToolSection.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/23/24.
//

import SwiftUI

struct ToolSection: View {
    var items: [ToolItem]
    var selectedTool: Tool?
    var onToolPress: (Tool) -> Void

    init(items: [ToolItem], selectedTool: Tool? = nil, onToolPress: @escaping (Tool) -> Void) {
        self.items = items
        self.selectedTool = selectedTool
        self.onToolPress = onToolPress
    }

    var body: some View {
        Section {
            ForEach(items) { item in
                ToolButton(item.tool, selectedTool: selectedTool, onToolPress: onToolPress)
            }
        }
    }
}

#if DEBUG
struct ToolSection_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ToolSection(
                items: [
                    ToolItem(.pencil),
                    ToolItem(.marker),
                    ToolItem(.eraser)
                ],
                selectedTool: .marker)
            { tool in
                print(tool)
            }
        }
    }
}
#endif
