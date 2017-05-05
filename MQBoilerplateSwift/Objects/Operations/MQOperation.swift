//
//  MQOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
An `MQOperation` is any task that needs to execute code at various points during its execution
and depending on whether it succeeds or fails. This is a subclass of `NSOperation` and must be
added to an `NSOperationQueue` to execute. For an asynchronous implementation, see `MQAsynchronousOperation`.
*/
open class MQOperation: Operation {
    
    /**
    Executed when the operation begins. For example, you can show a loading screen in this block.
    */
    open var startBlock: (() -> Void)?
    
    /**
    Executed when the operation finishes processing but before a success or failure status is determined.
    */
    open var returnBlock: (() -> Void)?
    
    /**
    Executed when the operation produces an error, e.g., show an error dialog.
    */
    open var failureBlock: ((NSError) -> Void)?
    
    /**
    Executed when the operation produces a result, e.g., showing a `UITableView` of results.
    */
    open var successBlock: ((Any?) -> Void)?
    
    /**
    Executed before the operation closes regardless of whether it succeeds or fails, e.g., closing I/O streams.
    */
    open var finishBlock: (() -> Void)?
    
    /**
     The object that builds an `NSError` object from `ErrorType`s thrown in `do` statements.
     */
    open var errorBuilder: MQErrorBuilder {
        fatalError("Override this property and supply your custom error builder.")
    }
    
    /**
    Defines the operation and at which points the callback blocks are executed.
    */
    open override func main() {
        defer {
            if self.isCancelled == false {
                self.runFinishBlock()
            }
        }
        
        if self.isCancelled {
            return
        }
        
        self.runStartBlock()
        
        if self.isCancelled {
            return
        }
        
        self.runReturnBlock()
        
        if self.isCancelled {
            return
        }
        
        do {
            let result = try buildResult(nil)
            self.runSuccessBlockWithResult(result)
        } catch {
            self.runFailureBlockWithError(error as NSError)
        }
    }
    
    /**
    Override point for converting the raw result (usually a JSON object) into your own custom object or value type.
    The function throws an error if the `rawResult` can't be meaningfully converted into a custom type.
    Otherwise, the function denotes success by returning with or without a custom value.
    */
    open func buildResult(_ rawResult: Any?) throws -> Any? {
        return nil
    }
    
    /**
    Performs the `startBlock` in the main UI thread and waits until it is finished.
    */
    open func runStartBlock() {
        if let startBlock = self.startBlock {
            if self.isCancelled {
                return
            }
            
            MQDispatcher.syncRunInMainThread(startBlock)
        }
    }
    
    /**
    Performs the `returnBlock` in the main UI thread and waits until it is finished.
    */
    open func runReturnBlock() {
        if let returnBlock = self.returnBlock {
            if self.isCancelled {
                return
            }
            
            MQDispatcher.syncRunInMainThread(returnBlock)
        }
    }
    
    /**
    Performs the `successBlock` in the main UI thread and waits until it is finished.
    */
    open func runSuccessBlockWithResult(_ result: Any?) {
        if let successBlock = self.successBlock {
            if self.isCancelled {
                return
            }
            
            MQDispatcher.syncRunInMainThread {
                successBlock(result)
            }
        }
    }
    
    /**
    Performs the `failureBlock` in the main UI thread and waits until it is finished.
    */
    open func runFailureBlockWithError(_ error: NSError) {
        if let failureBlock = self.failureBlock {
            if self.isCancelled {
                return
            }
            MQDispatcher.syncRunInMainThread {
                failureBlock(error)
            }
        }
    }
    
    /**
     Automatically converts `ErrorType` objects to an `NSError` object based on `self.errorBuilder`
     and calls `self.runFailurBlockWithError` with the generated error object.
     */
//    open func runFailureBlockWithError(_ error: Error) {
//        let errorObject = self.errorBuilder.errorObjectForError(error)
//        self.runFailureBlockWithError(errorObject)
//    }
    
    /**
    Performs the `finishBlock` in the main UI thread and waits until it is finished.
    */
    open func runFinishBlock() {
        if let finishBlock = self.finishBlock {
            if self.isCancelled {
                return
            }
            
            MQDispatcher.syncRunInMainThread(finishBlock)
        }
    }
    
    /**
    Overrides the current `failureBlock` to show an error dialog in a provided `UIViewController`.
    */
    open func overrideFailureBlockToShowErrorDialogInPresenter(_ presenter: UIViewController) {
        self.failureBlock = {[unowned presenter] error in
            if self.isCancelled {
                return
            }
            
            MQErrorDialog.showError(error, inPresenter: presenter)
        }
    }
    
}
