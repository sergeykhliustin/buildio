//
//  SplitNavigationController.swift
//  SplitNavigation
//
//  Created by Sergey Khliustin on 18.01.2022.
//

import Foundation
import UIKit
import SwiftUI

struct SplitNavigationView<Content: View>: UIViewControllerRepresentable {
    typealias UIViewControllerType = SplitNavigationController
    @Environment(\.fullscreen) private var fullscreen
    @Environment(\.theme) private var theme
    @Environment(\.windowMode) private var windowMode
    @EnvironmentObject private var navigator: Navigator
    private let shouldSplit: Bool
    @ViewBuilder private var content: () -> Content
    
    init(shouldSplit: Bool,
         content: @escaping () -> Content) {
        self.shouldSplit = shouldSplit
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> SplitNavigationController {
        let rootViewController = UIHostingController(rootView: content())
        let controller = SplitNavigationController(rootViewController: rootViewController)
        navigator.navigationController = controller
        controller.navigator = navigator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SplitNavigationController, context: Context) {
        if (windowMode == .split && shouldSplit) && !fullscreen.wrappedValue {
            navigator.navigationController?.mode = .primarySecondary
        } else {
            navigator.navigationController?.mode = .primaryOnly
        }
        
        navigator.navigationController?.updateTheme(theme)
    }
}

private final class EmptyViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
    }
}

final class SplitNavigationController: UIViewController {
    struct Constants {
        static let separatorWidth = 1.0
        static let primaryWidth = 300.0
        static let iphonePresentationCornerRadius = 38.0
        static let ipadPresentationCornerRadius = 10.0
        static let presentationWidth = 700.0
        static let ipadPresentationHeightOffset = 80.0
    }
    enum Mode {
        case primaryOnly
        case primarySecondary
    }
    
    private let rootViewController: UIViewController
    private let primaryNavigationController: UINavigationController
    private let secondaryNavigationController: UINavigationController
    private var customPresentedController: UIViewController?
    
    private var fadeView: UIView?
    private var fadeColor: UIColor = .clear {
        didSet {
            fadeView?.backgroundColor = fadeColor
        }
    }
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    fileprivate weak var navigator: Navigator?
    
    var mode: Mode = .primaryOnly {
        didSet {
            if oldValue != mode {
                if mode == .primaryOnly {
                    switchToPrimaryOnly()
                } else {
                    switchToPrimarySecondary()
                }
            }
        }
    }
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.primaryNavigationController = Self.navigationController(rootViewController)
        self.secondaryNavigationController = Self.navigationController(EmptyViewController())
        super.init(nibName: nil, bundle: nil)
    }
    
    func push(_ controller: UIViewController, animated: Bool = true, shouldReplace: Bool) {
        switch mode {
        case .primaryOnly:
            primaryNavigationController.pushViewController(controller, animated: animated)
        case .primarySecondary:
            if secondaryNavigationController.topViewController is EmptyViewController || shouldReplace {
                secondaryNavigationController.setViewControllers([controller], animated: animated && !shouldReplace)
            } else {
                secondaryNavigationController.pushViewController(controller, animated: animated)
            }
        }
        controller.view.backgroundColor = .clear
    }
    
    func pop() {
        switch mode {
        case .primaryOnly:
            primaryNavigationController.popViewController(animated: true)
        case .primarySecondary:
            secondaryNavigationController.popViewController(animated: true)
        }
    }
    
    func popToRoot() {
        switch mode {
        case .primaryOnly:
            primaryNavigationController.popToRootViewController(animated: true)
        case .primarySecondary:
            primaryNavigationController.popToRootViewController(animated: true)
            if !(secondaryNavigationController.topViewController is EmptyViewController) {
                var viewControllers = secondaryNavigationController.viewControllers
                viewControllers.insert(EmptyViewController(), at: 0)
                secondaryNavigationController.setViewControllers(viewControllers, animated: false)
                secondaryNavigationController.popToRootViewController(animated: true)
            }
        }
        
        dismissSheet()
    }
    
    func sheet(_ controller: UIViewController) {
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.backgroundColor = view.backgroundColor
        #if targetEnvironment(macCatalyst)
        controller.view.layer.cornerRadius = Constants.ipadPresentationCornerRadius
        controller.view.layer.masksToBounds = true
        #else
        if UIDevice.current.userInterfaceIdiom == .phone {
            controller.view.layer.cornerRadius = Constants.iphonePresentationCornerRadius
            controller.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            controller.view.layer.cornerRadius = Constants.ipadPresentationCornerRadius
            controller.view.layer.masksToBounds = true
        }
        #endif
        view.addSubview(controller.view)
        addChild(controller)
        didMove(toParent: self)
        
        controller.view.constraints.forEach({ controller.view.removeConstraint($0) })
        
        var centerY = controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height).priority(.defaultHigh)
        var constraints = [
            centerY,
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        if UIDevice.current.userInterfaceIdiom == .phone {
            constraints.append(controller.view.widthAnchor.constraint(equalTo: view.widthAnchor))
            constraints.append(controller.view.heightAnchor.constraint(equalTo: view.heightAnchor))
        } else {
            constraints.append(controller.view.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -Constants.ipadPresentationHeightOffset))
            constraints.append(controller.view.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.presentationWidth))
            constraints.append(controller.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 0))
            constraints.append(controller.view.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor))
            constraints.append(controller.view.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor))
            
            constraints.append(controller.view.widthAnchor.constraint(equalToConstant: Constants.presentationWidth).priority(.defaultHigh))
        }
        
        NSLayoutConstraint.activate(constraints)
        
        self.fadeView = createFadeView()
        view.bringSubviewToFront(controller.view)
        
        view.layoutIfNeeded()
        controller.view.removeConstraint(centerY)
        centerY = controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([
            centerY
        ])
        UIView.animate(withDuration: 0.4) {
            self.fadeView?.alpha = 1.0
            self.view.layoutIfNeeded()
        }
        
        customPresentedController = controller
    }
    
    @objc private func navigatorDismiss() {
        navigator?.dismiss()
    }
    
    func dismissSheet() {
        guard let customPresentedController = customPresentedController else {
            return
        }
        let presentedView = customPresentedController.view!
        UIView.animate(
            withDuration: 0.4,
            animations: {
                var frame = presentedView.frame
                frame.origin.y = self.view.frame.size.height
                presentedView.frame = frame
                self.fadeView?.alpha = 0
            },
            completion: { _ in
                self.fadeView?.removeFromSuperview()
                self.fadeView = nil
                
                customPresentedController.willMove(toParent: nil)
                customPresentedController.view.removeFromSuperview()
                customPresentedController.removeFromParent()
            })
        self.customPresentedController = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        primaryNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        secondaryNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        switchToPrimaryOnly()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTheme(_ theme: Theme) {
        fadeColor = theme.fadeColor.uiColor
        view.backgroundColor = theme.background.uiColor
        separator.backgroundColor = theme.separatorColor.uiColor
        
        for navigation in [primaryNavigationController, secondaryNavigationController] {
            navigation.viewControllers.first?.view.backgroundColor = theme.background.uiColor
            let navigationBar = navigation.navigationBar
            
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithTransparentBackground()
            navigationBarAppearance.backgroundColor = UIColor(theme.background)
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: theme.navigationColor.uiColor]
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: theme.navigationColor.uiColor]
            navigationBarAppearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: theme.navigationColor.uiColor]
            navigationBar.tintColor = theme.navigationColor.uiColor
            navigationBar.standardAppearance = navigationBarAppearance
            navigationBar.compactAppearance = navigationBarAppearance
            navigationBar.scrollEdgeAppearance = navigationBarAppearance
        }
        
        customPresentedController?.view.backgroundColor = theme.background.uiColor
    }
    
    private static func navigationController(_ rootViewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.navigationBar.prefersLargeTitles = true
        return navigation
    }
    
    private func createFadeView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = fadeColor
        view.alpha = 0
        
        let superview: UIView = self.view        
        superview.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.leftAnchor.constraint(equalTo: superview.leftAnchor),
            view.rightAnchor.constraint(equalTo: superview.rightAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigatorDismiss)))
        
        return view
    }
    
    private func switchToPrimarySecondary() {
        var viewControllers = primaryNavigationController.viewControllers
        if viewControllers.count > 1 {
            primaryNavigationController.popToRootViewController(animated: false)
            viewControllers.removeFirst()
            viewControllers.forEach({
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            })
            secondaryNavigationController.setViewControllers(viewControllers, animated: false)
        } else {
            secondaryNavigationController.viewControllers = [ EmptyViewController() ]
        }
        
        view.addSubview(secondaryNavigationController.view)
        
        addChild(secondaryNavigationController)
        didMove(toParent: secondaryNavigationController)
        
        view.addSubview(separator)
        
        view.constraints
            .relatedTo(view: primaryNavigationController.view)
            .forEach({
                view.removeConstraint($0)
            })
        view.constraints
            .relatedTo(view: secondaryNavigationController.view)
            .forEach({
                view.removeConstraint($0)
            })
        
        primaryNavigationController.view.constraints.forEach({
            if $0.firstItem as? AnyHashable == view as AnyHashable || $0.secondItem as? AnyHashable == view as AnyHashable {
                primaryNavigationController.view.removeConstraint($0)
            }
        })
        
        secondaryNavigationController.view.constraints.forEach({
            if $0.firstItem as? AnyHashable == view as AnyHashable || $0.secondItem as? AnyHashable == view as AnyHashable {
                secondaryNavigationController.view.removeConstraint($0)
            }
        })
        
        let layoutGuide = view!
        
        NSLayoutConstraint.activate([
            primaryNavigationController.view.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            primaryNavigationController.view.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor),
            primaryNavigationController.view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            primaryNavigationController.view.widthAnchor.constraint(equalToConstant: Constants.primaryWidth),
            
            separator.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            separator.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            separator.leftAnchor.constraint(equalTo: primaryNavigationController.view.rightAnchor),
            separator.widthAnchor.constraint(equalToConstant: Constants.separatorWidth),
            
            secondaryNavigationController.view.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            secondaryNavigationController.view.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor),
            secondaryNavigationController.view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            secondaryNavigationController.view.leftAnchor.constraint(equalTo: separator.rightAnchor)
        ])
        
        if let fadeView = fadeView {
            view.bringSubviewToFront(fadeView)
        }
        if let presented = customPresentedController {
            view.bringSubviewToFront(presented.view)
        }
    }
    
    private func switchToPrimaryOnly() {
        let viewControllers = (primaryNavigationController.viewControllers + secondaryNavigationController.viewControllers).filter({ !($0 is EmptyViewController) })
        
        primaryNavigationController.viewControllers = viewControllers
        secondaryNavigationController.viewControllers = [ EmptyViewController() ]
        
        secondaryNavigationController.willMove(toParent: nil)
        secondaryNavigationController.removeFromParent()
        secondaryNavigationController.view.removeFromSuperview()
        
        view.addSubview(primaryNavigationController.view)
        addChild(primaryNavigationController)
        didMove(toParent: primaryNavigationController)
        
        primaryNavigationController.view.constraints.forEach({
            primaryNavigationController.view.removeConstraint($0)
        })
        
        let layoutGuide = view!
        
        NSLayoutConstraint.activate([
            primaryNavigationController.view.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            primaryNavigationController.view.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor),
            primaryNavigationController.view.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor),
            primaryNavigationController.view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
        ])
        
        if let fadeView = fadeView {
            view.bringSubviewToFront(fadeView)
        }
        if let presented = customPresentedController {
            view.bringSubviewToFront(presented.view)
        }
    }
}
