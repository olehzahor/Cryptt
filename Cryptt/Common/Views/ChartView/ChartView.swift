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
            .foregroundColor: UIColor.blue
        ]

        return NSAttributedString(string: CRNumberFormatter.formatCurrency(price),
                                  attributes: attributes)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let minValue = prices.min() ?? 0.0
        let maxValue = prices.max() ?? 0.0
        let delta = maxValue - minValue
        
        context.setStrokeColor(strokeColor)
        context.setLineWidth(1)
        context.beginPath()
        
        prices.enumerated().forEach { index, value in
            let relativeY = Double(maxValue - value) / Double(delta)
            let relativeX = Double(index) / Double(prices.count - 1)
            
            let point = CGPoint(x: frame.width * relativeX,
                                y: frame.height * relativeY)
            
            if index == 0 {
                context.move(to: point)
            } else {
                context.addLine(to: point)
                context.move(to: point)
            }
        }
        context.strokePath()
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
