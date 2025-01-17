//
//  PageView.swift
//  ConquestSwift
//
//  Created by changju.kim on 1/10/25.
//
import PDFKit
import UIKit

class PageView: UIImageView {
    var sourceSize: CGSize
    var ratio: Double = 0
    var width: Double = 0
    var height: Double = 0 {
        didSet {
            width = height * ratio
            frame.size = CGSize(width: width, height: height)
        }
    }

    init() {
        guard let image = renderPDFPageAsImage(pdfName: "12925", pageNumber: 1) else {
            fatalError("")
        }

        sourceSize = image.size
        ratio = image.size.width / image.size.height

        super.init(image: image)

        contentMode = .scaleAspectFit
    }

    func setPage(bookId: String, pageIndex: Int) {
        guard let pageImage = renderPDFPageAsImage(pdfName: "12925", pageNumber: pageIndex) else {
            fatalError("")
        }
        image = pageImage
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("unavailable")
    }
}

func renderPDFPageAsImage(pdfName: String, pageNumber: Int) -> UIImage? {
    // Load the PDF document from the main bundle
    guard let pdfURL = Bundle.main.url(forResource: pdfName, withExtension: "pdf"),
          let pdfDocument = PDFDocument(url: pdfURL),
          let page = pdfDocument.page(at: pageNumber - 1)
    else { // PDF pages are 0-based
        print("Unable to load PDF or specified page")
        return nil
    }

    // Define the rendering size and scale
    let pageBounds = page.bounds(for: .mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageBounds.size)

    // Render the page into an image
    let image = renderer.image { context in
        context.cgContext.translateBy(x: 0, y: pageBounds.size.height)
        context.cgContext.scaleBy(x: 1.0, y: -1.0)
        page.draw(with: .mediaBox, to: context.cgContext)
    }

    return image
}
