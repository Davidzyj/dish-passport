import AppKit
import CoreGraphics
import CoreText
import Foundation
import ImageIO
import UniformTypeIdentifiers

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let iconSet = root.appendingPathComponent("DishPassport/Assets.xcassets/AppIcon.appiconset")
try FileManager.default.createDirectory(at: iconSet, withIntermediateDirectories: true)

func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> CGColor {
    CGColor(red: red, green: green, blue: blue, alpha: 1)
}

func makeIcon(size: Int) -> CGImage {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let context = CGContext(
        data: nil,
        width: size,
        height: size,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
    ) else {
        fatalError("Unable to create CGContext")
    }

    let scale = CGFloat(size) / 1024.0
    func rect(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect {
        CGRect(x: x * scale, y: y * scale, width: w * scale, height: h * scale)
    }
    func rounded(_ r: CGRect, radius: CGFloat, fill: CGColor) {
        let path = CGPath(roundedRect: r, cornerWidth: radius * scale, cornerHeight: radius * scale, transform: nil)
        context.setFillColor(fill)
        context.addPath(path)
        context.fillPath()
    }
    func drawText(_ text: String, in r: CGRect, fontSize: CGFloat, weight: NSFont.Weight, fill: CGColor) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: fontSize * scale, weight: weight),
            .foregroundColor: NSColor(cgColor: fill) ?? .black,
            .paragraphStyle: paragraph
        ]
        let string = NSAttributedString(string: text, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(string)
        let path = CGPath(rect: r, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, string.length), path, nil)
        CTFrameDraw(frame, context)
    }

    let background = color(0.969, 0.945, 0.902)
    let paper = color(1.0, 0.992, 0.973)
    let paperWarm = color(0.984, 0.961, 0.918)
    let chili = color(0.718, 0.192, 0.173)
    let chiliDark = color(0.561, 0.137, 0.122)
    let jade = color(0.184, 0.435, 0.384)
    let amber = color(0.847, 0.537, 0.173)
    let ink = color(0.122, 0.149, 0.137)

    context.setFillColor(background)
    context.fill(CGRect(x: 0, y: 0, width: size, height: size))

    rounded(rect(96, 96, 832, 832), radius: 188, fill: chili)
    rounded(rect(142, 142, 740, 740), radius: 148, fill: paper)
    rounded(rect(196, 190, 632, 644), radius: 116, fill: paperWarm)
    rounded(rect(245, 256, 520, 500), radius: 72, fill: jade)
    rounded(rect(291, 300, 428, 412), radius: 54, fill: paper)

    context.setStrokeColor(amber)
    context.setLineWidth(16 * scale)
    context.strokeEllipse(in: rect(306, 260, 412, 412))
    context.strokeEllipse(in: rect(340, 294, 344, 344))

    context.setStrokeColor(ink)
    context.setLineWidth(24 * scale)
    context.setLineCap(.round)
    context.move(to: CGPoint(x: 286 * scale, y: 812 * scale))
    context.addLine(to: CGPoint(x: 734 * scale, y: 234 * scale))
    context.strokePath()
    context.move(to: CGPoint(x: 342 * scale, y: 828 * scale))
    context.addLine(to: CGPoint(x: 790 * scale, y: 250 * scale))
    context.strokePath()

    context.saveGState()
    context.translateBy(x: 0, y: CGFloat(size))
    context.scaleBy(x: 1, y: -1)
    drawText("味", in: rect(262, 325, 500, 350), fontSize: 314, weight: .black, fill: chiliDark)
    drawText("PASS", in: rect(334, 692, 356, 92), fontSize: 72, weight: .heavy, fill: amber)
    context.restoreGState()

    guard let image = context.makeImage() else {
        fatalError("Unable to create image")
    }
    return image
}

func writePNG(_ image: CGImage, to url: URL) throws {
    guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
        fatalError("Unable to create image destination")
    }
    CGImageDestinationAddImage(destination, image, nil)
    guard CGImageDestinationFinalize(destination) else {
        fatalError("Unable to write PNG")
    }
}

let sizes: [(String, Int)] = [
    ("Icon-20@2x.png", 40),
    ("Icon-20@3x.png", 60),
    ("Icon-29@2x.png", 58),
    ("Icon-29@3x.png", 87),
    ("Icon-40@2x.png", 80),
    ("Icon-40@3x.png", 120),
    ("Icon-60@2x.png", 120),
    ("Icon-60@3x.png", 180),
    ("Icon-1024.png", 1024)
]

for (name, size) in sizes {
    try writePNG(makeIcon(size: size), to: iconSet.appendingPathComponent(name))
}

let contents = """
{
  "images" : [
    { "filename" : "Icon-20@2x.png", "idiom" : "iphone", "scale" : "2x", "size" : "20x20" },
    { "filename" : "Icon-20@3x.png", "idiom" : "iphone", "scale" : "3x", "size" : "20x20" },
    { "filename" : "Icon-29@2x.png", "idiom" : "iphone", "scale" : "2x", "size" : "29x29" },
    { "filename" : "Icon-29@3x.png", "idiom" : "iphone", "scale" : "3x", "size" : "29x29" },
    { "filename" : "Icon-40@2x.png", "idiom" : "iphone", "scale" : "2x", "size" : "40x40" },
    { "filename" : "Icon-40@3x.png", "idiom" : "iphone", "scale" : "3x", "size" : "40x40" },
    { "filename" : "Icon-60@2x.png", "idiom" : "iphone", "scale" : "2x", "size" : "60x60" },
    { "filename" : "Icon-60@3x.png", "idiom" : "iphone", "scale" : "3x", "size" : "60x60" },
    { "filename" : "Icon-1024.png", "idiom" : "ios-marketing", "scale" : "1x", "size" : "1024x1024" }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""

try contents.write(to: iconSet.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
