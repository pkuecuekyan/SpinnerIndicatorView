//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

@IBDesignable class SpinnerIndicatorView: UIView {
    
    // MARK: - Properties (settable)
    
    private let circleLayer = CAShapeLayer()
    
    @IBInspectable var animating: Bool = true {
        didSet {
            updateAnimation()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 4 {
        didSet {
            circleLayer.lineWidth = lineWidth
            setNeedsLayout()
        }
    }
    
    @IBInspectable var strokeColor: UIColor = .red {
        didSet {
            circleLayer.strokeColor = strokeColor.cgColor
            setNeedsLayout()
        }
    }
    
    // MARK: - Properties (calculated)
    
    let strokeEndAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 1.25
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
    let strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 1.25
        group.repeatCount = MAXFLOAT
        group.animations = [animation]
        
        return group
    }()
    
    let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 2
        animation.repeatCount = MAXFLOAT
        return animation
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - View lifecycle
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - circleLayer.lineWidth/2
        
        let startAngle = CGFloat(-Double.pi/2)
        let endAngle = startAngle + CGFloat(Double.pi * 2)
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        circleLayer.position = center
        circleLayer.path = path.cgPath
    }
    
    // MARK: - View helper methods
    
    func updateAnimation() {
        if animating {
            circleLayer.add(strokeEndAnimation, forKey: "strokeEnd")
            circleLayer.add(strokeStartAnimation, forKey: "strokeStart")
        }
        else {
            circleLayer.removeAnimation(forKey: "strokeEnd")
            circleLayer.removeAnimation(forKey: "strokeStart")
        }
    }
    
    func setup() {
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = nil
        circleLayer.strokeColor = strokeColor.cgColor
        layer.addSublayer(circleLayer)
        tintColorDidChange()
    }
    
}

class SpinnerViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let spinnerIndicator = SpinnerIndicatorView(frame: CGRect(x: 100.0, y: 100.0, width: 50.0, height: 50.0))
        
        view.addSubview(spinnerIndicator)
        spinnerIndicator.animating = true
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = SpinnerViewController()
