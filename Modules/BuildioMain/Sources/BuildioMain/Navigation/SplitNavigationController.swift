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
    let overridedTheme: Theme?
    private let shouldSplit: Bool
    @ViewBuilder private var content: () -> Content
    
    init(shouldSplit: Bool,
         overridedTheme: Theme? = nil,
         content: @escaping () -> Content) {
        self.shouldSplit = shouldSplit
        self.content = content
        self.overridedTheme = overridedTheme
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
        
        navigator.updateTheme(overridedTheme ?? theme)
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
    private let separatorWidth: CGFloat = 1.0
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
    }
    
    func sheet(_ controller: UIViewController) {
        present(controller, animated: true)
        controller.view.backgroundColor = view.backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryNavigationController.view)
        addChild(primaryNavigationController)
        didMove(toParent: primaryNavigationController)
        
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
        
        presentedViewController?.view.backgroundColor = theme.background.uiColor
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
        
        view.constraints.forEach({
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
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if view.frame.width > minumumPrimaryWidth * 2 + separatorWidth {
//            self.mode = .primarySecondary
//        } else {
//            self.mode = .primaryOnly
//        }
//    }
}
