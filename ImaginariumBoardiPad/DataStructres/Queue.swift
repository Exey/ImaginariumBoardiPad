//
//  Queue.swift
//  ImaginariumBoardiPad
//
//  Created by Exey Panteleev on 12.06.2022.
//

import Foundation

struct Queue<T> {
    
  var elements: [T] = []

  mutating func enqueue(_ value: T) {
    elements.append(value)
  }

  mutating func dequeue() -> T? {
    guard !elements.isEmpty else {
      return nil
    }
    return elements.removeFirst()
  }

  var head: T? {
    return elements.first
  }

  var tail: T? {
    return elements.last
  }
    
}
