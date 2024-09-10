import UIKit
import Combine
import ObjectiveC

private class TapGestureHandler: NSObject {
    private let subject: PassthroughSubject<Void, Never>
    
    init(subject: PassthroughSubject<Void, Never>) {
        self.subject = subject
    }
    
    @objc func handleTap() {
        subject.send(())
    }
}

public extension UIView {
    private struct AssociatedKeys {
        static var tapGestureHandler = "tapGestureHandler"
    }

    private var tapGestureHandler: TapGestureHandler? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tapGestureHandler) as? TapGestureHandler
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapGestureHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func tapPublisher() -> AnyPublisher<Void, Never> {
        let tapSubject = PassthroughSubject<Void, Never>()
        
        let tapGesture = UITapGestureRecognizer()
        let handler = TapGestureHandler(subject: tapSubject)
        
        tapGesture.addTarget(handler, action: #selector(handler.handleTap))
        addGestureRecognizer(tapGesture)
        
        // Store the handler in the view to keep it alive
        self.tapGestureHandler = handler
        
        return tapSubject.eraseToAnyPublisher()
    }
    
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
