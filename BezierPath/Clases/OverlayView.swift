import UIKit

class OverlayView: UIView {
    
    private let defaultScreenHeight: CGFloat = 667
    private let defaultRadius: CGFloat = 440
    
    var circleCenter: CGPoint = .zero
    var smallCircleRadius: CGFloat = 0
    
    private var rad: CGFloat {
        return CGFloat(Double.pi)
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderUI() {
        backgroundColor = .clear
        
        let transparentPath = smallCirclePath
        
        let maskPath = largeCirclePath
        maskPath.append(transparentPath)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.green.withAlphaComponent(0.4),
            UIColor.purple.withAlphaComponent(0.4)
            ].map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint (x: 1, y: 0.5)
        gradientLayer.frame = bounds
        gradientLayer.mask = maskLayer
        
        layer.addSublayer(gradientLayer)
    }
    
    private var smallCirclePath: UIBezierPath {
        return circlePath(radius: smallCircleRadius)
    }
    
    private var largeCirclePath: UIBezierPath  {
        var radius = defaultRadius
        let radiusRate = defaultRadius / defaultScreenHeight
        
        if bounds.height != defaultScreenHeight {
            radius = bounds.height * radiusRate
        }
        
        return circlePath(radius: radius)
    }
    
    private func circlePath(radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.addArc(withCenter: circleCenter,
                    radius: radius,
                    startAngle: 0,
                    endAngle: rad * 2,
                    clockwise: true)
        
        return path
    }
}
