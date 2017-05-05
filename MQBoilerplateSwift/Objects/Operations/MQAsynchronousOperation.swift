//
//  MQAsynchronousOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
An `MQOperation` subclass that runs asynchronously. It overrides the properties and
functions that are required to be overriden when implementing an asynchronous `NSOperation`.
*/
open class MQAsynchronousOperation: MQOperation {
    
    // MARK: Internal state variables
    
    fileprivate var _executing = false
    fileprivate var _finished = false
    
    // MARK: NSOperation required overrides
    
    open override var isConcurrent: Bool {
        return true
    }
    
    open override var isAsynchronous: Bool {
        return true
    }
    
    open override var isExecuting: Bool {
        return self._executing
    }
    
    open override var isFinished: Bool {
        return self._finished
    }
    
    open override func start() {
        if self.isCancelled {
            self.willChangeValue(forKey: "isFinished")
            self._finished = true
            self.didChangeValue(forKey: "isFinished")
            return
        }
        
        self.willChangeValue(forKey: "isExecuting")
        Thread.detachNewThreadSelector(#selector(Operation.main), toTarget: self, with: nil)
        self._executing = true
        self.didChangeValue(forKey: "isExecuting")
    }
    
    open override func main() {
        defer {
            if self.isCancelled == false {
            self.runFinishBlock()
            }
            self.closeOperation()
        }
        
        self.runStartBlock()
        self.runReturnBlock()
        do {
            let result = try self.buildResult(nil)
            self.runSuccessBlockWithResult(result)
        } catch {
            self.runFailureBlockWithError(error as NSError)
        }
    }
    
    open func closeOperation() {
        self.willChangeValue(forKey: "isExecuting")
        self.willChangeValue(forKey: "isFinished")
        
        self._executing = false
        self._finished = true
        
        self.didChangeValue(forKey: "isExecuting")
        self.didChangeValue(forKey: "isFinished")
    }
    
}
