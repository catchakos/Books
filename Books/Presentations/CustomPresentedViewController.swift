//
//  CustomPresentedViewController.swift
//  Books
//
//  Created by Alexis Katsaprakakis on 12/3/22.
//

import UIKit

protocol CustomPresentedViewController {
    var containerViewForCustomPresentation: UIView { get }
    var backgroundViewForCustomPresentation: UIView { get }
}
