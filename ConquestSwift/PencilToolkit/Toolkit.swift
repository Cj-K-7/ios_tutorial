//
//  PencilToolkitPanel.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/23/24.
//

import SwiftUI

struct Toolkit: View {
    @ObservedObject var model: ToolkitModel

    var sections: [ToolSectionItem] = [
        ToolSectionItem(
            ToolItem(.redo),
            ToolItem(.undo)
        ),
        ToolSectionItem(
            ToolItem(.list),
            ToolItem(.bundle),
            ToolItem(.star)
        ),
        ToolSectionItem(
            ToolItem(.pencil),
            ToolItem(.marker),
            ToolItem(.eraser)
        ),
    ]

    var onToolPress: (Tool) -> Void

    var body: some View {
        HStack {
            ForEach(sections) { section in
                ToolSection(
                    items: section.toolitems,
                    selectedTool: model.currentTool,
                    onToolPress: onToolPress
                )
            }
        }
    }
}

#if DEBUG
struct PencilToolkitPanel_Preview: PreviewProvider {
    static var previews: some View {
        let model = ToolkitModel()
        Toolkit(model: model, onToolPress: { tool in print(tool) })
    }
}
#endif
