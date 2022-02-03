//
//  BaseView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI
import BuildioLogic

protocol BaseView: View {
    associatedtype ModelType: BaseViewModelProtocol
    var model: ModelType { get }
}
