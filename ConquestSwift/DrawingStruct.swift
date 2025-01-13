//
//  DrawingStruct.swift
//  ConquestSwift
//
//  Created by changju.kim on 1/10/25.
//

struct Drawing: Codable {
    let key: String
    let userId: Int
    let packageId: String
    let pageId: String
    let period: Int
    let quizId: String
    let round: Int
    let solutionId: String
    let canvasAspectRatio: Float
    let canvasType: String
    let size: Size

    let strokes: [Stroke]

    enum CodingKeys: String, CodingKey {
        case canvasAspectRatio = "canvas_aspect_ratio"
        case canvasType = "canvas_type"

        case userId = "user_id"
        case packageId = "package_id"
        case pageId = "page_id"
        case quizId = "quiz_id"
        case solutionId = "solution_id"

        case size
        case key
        case period
        case round
        case strokes
    }
}

// Size structure
struct Size: Codable {
    let height: Double
    let width: Double
}

// Stroke structure
struct Stroke: Codable {
    let key: String
    let strokeID: String
    let strokeType: String
    let strokeWidth: Int
    let strokeColor: String
    let paths: [Path]
    let createdTime: Int
    let updatedTime: Int

    enum CodingKeys: String, CodingKey {
        case key
        case strokeID = "stroke_id"
        case strokeType = "stroke_type"
        case strokeWidth = "stroke_width"
        case strokeColor = "stroke_color"
        case paths
        case createdTime = "created_time"
        case updatedTime = "updated_time"
    }
}

// Path structure
struct Path: Codable {
    let x: Double
    let y: Double
    let force: Double?
}
