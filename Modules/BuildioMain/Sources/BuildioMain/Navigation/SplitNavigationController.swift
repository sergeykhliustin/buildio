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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
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
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SplitNavigationController, context: Context) {
        if (horizontalSizeClass == .regular && shouldSplit) && !fullscreen.wrappedValue {
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
    enum Mode {
        case primaryOnly
        case primarySecondary
    }
    private let minumumPrimaryWidth: CGFloat = 300.0
    private let rootViewController: UIViewController
    private let primaryNavigationController: UINavigationController
    private let secondaryNavigationController: UINavigationController
    private var customPresentedController: UIViewController?
    private let separatorWidth: CGFloat = 1.0
    private lazy var fadeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        self.view.addSubview(view)
        view.isHidden = true
        return view
    }()
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    private weak var navigator: Navigator?
    
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
        #if !targetEnvironment(macCatalyst)
        controller.view.layer.cornerRadius = 38
        if UIDevice.current.userInterfaceIdiom == .phone {
            controller.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
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
            constraints.append(controller.view.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -80))
            constraints.append(controller.view.widthAnchor.constraint(lessThanOrEqualToConstant: 800))
            constraints.append(controller.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 0))
            constraints.append(controller.view.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor))
            constraints.append(controller.view.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor))
            
            constraints.append(controller.view.widthAnchor.constraint(equalToConstant: 800).priority(.defaultHigh))
        }
        
        NSLayoutConstraint.activate(constraints)
        fadeView.alpha = 0
        fadeView.isHidden = false
        fadeView.constraints.forEach({ fadeView.removeConstraint($0) })
        
        NSLayoutConstraint.activate([
            fadeView.topAnchor.constraint(equalTo: self.view.topAnchor),
            fadeView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            fadeView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            fadeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        view.layoutIfNeeded()
        controller.view.removeConstraint(centerY)
        centerY = controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([
            centerY
        ])
        UIView.animate(withDuration: 0.4) {
            self.fadeView.alpha = 1.0
            self.view.layoutIfNeeded()
        }
        
        customPresentedController = controller
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
                self.fadeView.alpha = 0
            },
            completion: { _ in
                self.fadeView.isHidden = true
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
        view.backgroundColor = theme.background.uiColor
        separator.backgroundColor = theme.borderColor.uiColor
        
        for navigation in [primaryNavigationController, secondaryNavigationController] {
            navigation.viewControllers.first?.view.backgroundColor = theme.background.uiColor
            let navigationBar = navigation.navigationBar
            navigationBar.standardAppearance = UINavigationBar.appearance().standardAppearance
            navigationBar.compactAppearance = UINavigationBar.appearance().compactAppearance
            navigationBar.scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
        }
        
        customPresentedController?.view.backgroundColor = theme.background.uiColor
    }
    
    private static func navigationController(_ rootViewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.navigationBar.prefersLargeTitles = true
        return navigation
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
        
//        view.constraints.forEach({
//            view.removeConstraint($0)
//        })
        
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
            primaryNavigationController.view.widthAnchor.constraint(equalToConstant: minumumPrimaryWidth),
            
            separator.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            separator.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            separator.leftAnchor.constraint(equalTo: primaryNavigationController.view.rightAnchor),
            separator.widthAnchor.constraint(equalToConstant: separatorWidth),
            
            secondaryNavigationController.view.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            secondaryNavigationController.view.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor),
            secondaryNavigationController.view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            secondaryNavigationController.view.leftAnchor.constraint(equalTo: separator.rightAnchor)
        ])
        
        view.bringSubviewToFront(fadeView)
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
        
        view.bringSubviewToFront(fadeView)
        if let presented = customPresentedController {
            view.bringSubviewToFront(presented.view)
        }
    }
}
