//
//  ToolkitModel.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/23/24.
//

import Foundation

class ToolkitModel: ObservableObject {
    @Published var currentTool: Tool = .pencil
    @Published var lastDrawTool: Tool = .pencil

    func setTool(_ tool: Tool) {
        currentTool = tool
    }
}
