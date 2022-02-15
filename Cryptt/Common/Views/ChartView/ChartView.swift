//

import UIKit

protocol ChartViewInterface: UIView {
    func setData(_ prices: [Double])
}

protocol ChartViewDelegate: AnyObject {
    
}

class ChartView: UIView {
    weak var delegate: ChartViewDelegate?
    
    private var prices: [Double] = []

    private let strokeColor = UIColor.black.cgColor
        
    private func createString(price: Double) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.gray
        ]

        return NSAttributedString(string: CRNumberFormatter.formatCurrency(price),
                                  attributes: attributes)
    }
    
    private func calculateStringXPosition(stringSize: CGSize, pointX: CGFloat) -> CGFloat {
        let resultXPoint = pointX - stringSize.width / 2
        if resultXPoint < frame.minX {
            return frame.minX
        }
        if resultXPoint + stringSize.width > frame.maxX {
            return frame.maxX - stringSize.width
        }
        return resultXPoint
    }
    
    private func drawStrings(minValue: Double, minPoint: CGPoint,
                                 maxValue: Double, maxPoint: CGPoint) {
        let minString = createString(price: minValue)
        let adaptedMinPoint = CGPoint(x: calculateStringXPosition(stringSize: minString.size(),
                                                                  pointX: minPoint.x),
                                      y: minPoint.y + 5)
        let maxString = createString(price: maxValue)
        let adaptedMaxPoint = CGPoint(x: calculateStringXPosition(stringSize: maxString.size(),
                                                                  pointX: maxPoint.x),
                                      y: maxPoint.y - maxString.size().height - 5)
        minString.draw(at: adaptedMinPoint)
        maxString.draw(at: adaptedMaxPoint)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let minValue = prices.min() ?? 0.0
        let maxValue = prices.max() ?? 0.0
        let delta = maxValue - minValue
        
        context.setStrokeColor(strokeColor)
        context.setLineWidth(1)
        context.beginPath()
        
        var minPoint: CGPoint = .zero
        var maxPoint: CGPoint = .zero
        
        prices.enumerated().forEach { index, value in
            let relativeY = Double(maxValue - value) / Double(delta)
            let relativeX = Double(index) / Double(prices.count - 1)
            
            let point = CGPoint(x: frame.width * relativeX,
                                y: 25.0 + (frame.height - 50.0) * relativeY)
            
            if index == 0 {
                context.move(to: point)
            } else {
                context.addLine(to: point)
                context.move(to: point)
            }
            
            if value == minValue {
                minPoint = point
            }
            
            if value == maxValue {
                maxPoint = point
            }
        }
        context.strokePath()
        drawStrings(minValue: minValue, minPoint: minPoint,
                    maxValue: maxValue, maxPoint: maxPoint)
    }
    
    private func setupView() {
        backgroundColor = R.color.grayBg()
    }

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChartView: ChartViewInterface {
    func setData(_ prices: [Double]) {
        self.prices = prices
        setNeedsDisplay()
    }
}
