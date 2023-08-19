//
//  MFMNodeProtocol.swift
//  rawr.
//
//  Created by Nila on 19.08.2023.
//

import Foundation

protocol MFMNodeProtocol {
    var type: MFMNodeType { get }
    var value: String? { get }
    var children: [MFMNodeProtocol] { get set }
    var parentNode: MFMNodeProtocol? { get }
    
    func addChild(_ child: MFMNodeProtocol)
}
