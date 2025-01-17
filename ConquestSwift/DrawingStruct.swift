//
//  DrawingStruct.swift
//  ConquestSwift
//
//  Created by changju.kim on 1/10/25.
//
struct UserDrawingData: Codable {
    let userDrawList: [Drawing]

    enum CodingKeys: String, CodingKey {
        case userDrawList = "user_draw_list"
    }
}

struct Drawing: Codable {
    let key: String
    let userId: Int
    let packageId: String
    let pageId: String
    let period: Int
    let quizId: String
    let round: Int
    let solutionId: String
    let canvasAspectRatio: Float?
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

extension Drawing {
    func copy(
        key: String? = nil,
        userId: Int? = nil,
        packageId: String? = nil,
        pageId: String? = nil,
        period: Int? = nil,
        quizId: String? = nil,
        round: Int? = nil,
        solutionId: String? = nil,
        canvasAspectRatio: Float? = nil,
        canvasType: String? = nil,
        size: Size? = nil,
        strokes: [Stroke]? = nil
    ) -> Drawing {
        return Drawing(
            key: key ?? self.key,
            userId: userId ?? self.userId,
            packageId: packageId ?? self.packageId,
            pageId: pageId ?? self.pageId,
            period: period ?? self.period,
            quizId: quizId ?? self.quizId,
            round: round ?? self.round,
            solutionId: solutionId ?? self.solutionId,
            canvasAspectRatio: canvasAspectRatio ?? self.canvasAspectRatio,
            canvasType: canvasType ?? self.canvasType,
            size: size ?? self.size,
            strokes: strokes ?? self.strokes
        )
    }
}

extension Size {
    func copy(
        height: Double? = nil,
        width: Double? = nil
    ) -> Size {
        return Size(
            height: height ?? self.height,
            width: width ?? self.width
        )
    }
}

extension Stroke {
    func copy(
        key: String? = nil,
        strokeID: String? = nil,
        strokeType: String? = nil,
        strokeWidth: Int? = nil,
        strokeColor: String? = nil,
        paths: [Path]? = nil,
        createdTime: Int? = nil,
        updatedTime: Int? = nil
    ) -> Stroke {
        return Stroke(
            key: key ?? self.key,
            strokeID: strokeID ?? self.strokeID,
            strokeType: strokeType ?? self.strokeType,
            strokeWidth: strokeWidth ?? self.strokeWidth,
            strokeColor: strokeColor ?? self.strokeColor,
            paths: paths ?? self.paths,
            createdTime: createdTime ?? self.createdTime,
            updatedTime: updatedTime ?? self.updatedTime
        )
    }
}
