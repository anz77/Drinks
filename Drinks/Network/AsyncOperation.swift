//
//  AsyncOperation.swift
//  Drinks
//
//  Created by Andrii Zuiok on 14.09.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
  // Create state management
  enum State: String {
    case ready, executing, finished

    fileprivate var keyPath: String {
      return "is\(rawValue.capitalized)"
    }
  }

  var state = State.ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath) // new
      willChangeValue(forKey: state.keyPath) // current
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath) // old
      didChangeValue(forKey: state.keyPath) // current
    }
  }

  // Override properties
  override var isReady: Bool {
    return super.isReady && state == .ready
  }

  override var isExecuting: Bool {
    return state == .executing
  }

  override var isFinished: Bool {
    return state == .finished
  }

  override var isAsynchronous: Bool {
    return true
  }
  
//  override var isConcurrent: Bool {
//    return true
//  }

  // Override start
  override func start() {
    
    if isCancelled {
      state = .finished
      return
    }
    
    //Thread.detachNewThreadSelector(#selector(main), toTarget: self, with: nil)
    
    main()
    state = .executing
  }
}
