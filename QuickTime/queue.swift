//
//  queue.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/17/17.
//  Copyright © 2017 ASU. All rights reserved.
//queue class

import Foundation

// 1
public struct Queue<T> {
    
    // 2
    fileprivate var list = LinkedList<T>()
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    // 3
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    // 4
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        
        list.remove(element)
        
        return element.value
    }
    
    // 5
    public func peek() -> T? {
        return list.first?.value
    }
}
