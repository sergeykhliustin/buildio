//
//  BaseView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

protocol BaseView: View {
    associatedtype ModelType: BaseViewModelProtocol
    var model: ModelType { get }
}
