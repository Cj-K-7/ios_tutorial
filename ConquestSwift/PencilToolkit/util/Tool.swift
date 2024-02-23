//
//  Icon.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/23/24.
//

import Foundation

struct ToolItem: Identifiable, Equatable {
    let id = UUID()
    let tool: Tool

    init(_ tool: Tool) {
        self.tool = tool
    }
}

struct ToolSectionItem: Identifiable, Equatable {
    let id = UUID()
    var toolitems: [ToolItem]

    init(_ toolitems: ToolItem...) {
        self.toolitems = toolitems
    }
}

enum Tool {
    case pencil
    case marker
    case eraser
    case trap
    case list
    case bundle
    case star
    case undo
    case redo

    var icon: ToolIcon {
        switch self {
        case .pencil: return .pencil
        case .marker: return .marker
        case .eraser: return .eraser
        case .trap: return .trap
        case .list: return .list
        case .bundle: return .bundle
        case .star: return .star
        case .undo: return .undo
        case .redo: return .redo
        }
    }
}

enum ToolIcon: String {
    case pencil = "toolkit-icon-pen"
    case marker = "toolkit-icon-marker"
    case eraser = "toolkit-icon-eraser"
    case trap = "toolkit-icon-trap"
    case list = "icon-list"
    case bundle = "icon-bundle-definition"
    case star = "icon-star"
    case undo = "icon-undo"
    case redo = "icon-redo"
}
