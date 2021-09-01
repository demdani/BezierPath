import UIKit

class ViewController: UIViewController {
    
    private let overlay = OverlayView()
    
    private var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                return nil
        }
        
        return sceneDelegate.window
    }
    
    private var barButtonItem: UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setTitle("Rendezés", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.sizeToFit()
        return UIBarButtonItem(customView: button)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let correction: CGFloat = 10 // gives more space around the button -> increasing circle radius
        
        // calculating the radius of button
        let buttonFrame = navigationItem.rightBarButtonItem?.customView?.frame ?? .zero
        let radius = (buttonFrame.width + correction) / 2
        
        // hacky solution for retrieve x and y values of the button container, may broke in next ios versions
        guard let stackView = findStackView(in: navigationController!.navigationBar) else { return }
        
        // center x of the circle
        let x = stackView.frame.origin.x - correction / 2 + radius
    
        // navigation and status bar height
        let statusBarHeight: CGFloat = 20
        let navigationBarHeight: CGFloat = SafeArea.available ? 88 : 44
        
        // y should be in the center of the navigation bar
        let padding = navigationBarHeight / 2
        let y = statusBarHeight + padding
        
        overlay.circleCenter = CGPoint(x: x, y: y)
        overlay.smallCircleRadius = radius
        overlay.renderUI()
        
        window?.addSubview(overlay)
    }
    
    private func findStackView(in view: UIView) -> UIView? {
        var stackView: UIView?
        
        for subView in view.subviews {
            if subView is UIStackView {
                stackView = subView
                break
            } else {
                guard let currentView = findStackView(in: subView) else { continue }
                stackView = currentView
                break
            }
        }
        
        return stackView
    }
}

@objc public class SafeArea: NSObject {

    @objc public static var available: Bool {
        return bottom > 0
    }
    
    @objc public static var bottom: CGFloat {
        return insets.bottom
    }
    
    @objc public static var top: CGFloat {
        return insets.top
    }
    
    private static var insets: UIEdgeInsets {
        guard let window = window else {
            return .zero
        }
        return window.safeAreaInsets
    }
    
    private static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                return nil
        }
        
        return sceneDelegate.window
    }
}

