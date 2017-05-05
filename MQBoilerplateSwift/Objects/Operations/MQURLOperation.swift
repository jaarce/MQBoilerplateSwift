//
//  MQURLOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
A base implementation for an operation that makes URL requests.
*/
open class MQURLOperation: MQAsynchronousOperation {
    
    public enum Method: String {
        case OPTIONS = "OPTIONS"
        case GET = "GET"
        case HEAD = "HEAD"
        case POST = "POST"
        case PUT = "PUT"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
        case TRACE = "TRACE"
        case CONNECT = "CONNECT"
    }
    
    public enum ContentType {
        /**
        Sets the `Content-Type` HTTP header to `application/json`.
        */
        case json
        
        /**
        Sets the `Content-Type` HTTP header to `multipart/form-data; boundary=` plus
        the value of the `formDataBoundary` property. You must therefore set the `formDataBoundary`
        property if you choose this content type.
        */
        case multipartFormData
    }
    
    /**
    The `NSURLSession` object which creates the URL tasks. Ideally, you create subclasses of
    `MQURLOperation` that share a singleton `NSURLSession` object, and you simply pass the singleton
    to the `MQURLOperation` initializer.
    */
    open var session: URLSession
    open var method: MQURLOperation.Method
    open var URL: String
    
    /**
    The `Content-Type` HTTP header field.
    */
    open var contentType: ContentType
    
    open var parameters: [String : AnyObject]?
    
    /**
    The boundary string for multipart form data requests.
    */
    open var formDataBoundary: String!
    
    fileprivate var task: URLSessionDataTask!
    
    // MARK -
    
    public init(session: URLSession,
        method: MQURLOperation.Method,
        URL: String,
        contentType: ContentType,
        parameters: [String : AnyObject]? = nil) {
            self.session = URLSession.shared
            self.method = method
            self.URL = URL
            self.contentType = contentType
            self.parameters = parameters
    }
    
    /**
    Builds the URL request object on which the URL task will be based. To set your own HTTP headers,
    override this function and edit the request object returned by the `super` implementation.
    */
    open func createRequest() -> NSMutableURLRequest {
        let URLString = self.URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
        let request = NSMutableURLRequest(url: Foundation.URL(string: URLString)!)
        request.httpMethod = self.method.rawValue
        
        switch self.contentType {
        case .json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                if let parameters = self.parameters {
                    let HTTPBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.httpBody = HTTPBody
                    
                    
                    let _: NSString = NSString(data: HTTPBody, encoding: String.Encoding.ascii.rawValue)!
                    ////Debugger.debug(theString)
                    
                }
            } catch {
                fatalError("Cannot encode JSON parameters")
            }
            
        case .multipartFormData:
            guard let boundary = self.formDataBoundary else {
                fatalError("Initialised a multipart form data request without specifying formDataBoundary")
            }
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = self.createMultipartFormData() as Data
        }
        
        return request
    }
    
    /**
    Override point for building the HTTP body of a multipart form data request.
    If you set the `contentType` to `.MultipartFormData`, you must override this function.
    */
    open func createMultipartFormData() -> NSMutableData {
        fatalError("Did not override: \(#function)")
    }
    
    open override func main() {
        if self.isCancelled {
            self.closeOperation()
            return
        }
        
        self.runStartBlock()
        
        if self.isCancelled {
            self.closeOperation()
            return
        }
        
        let request = self.createRequest()
//        self.session.data
        self.session.dataTask(with: request as URLRequest) { (data, response, error) in
            self.handleResponse(response, data, error)
        }
        self.task.resume()
    }
    
    /**
    Handles the response returned by the server. You should override this method in a base
    `MQURLOperation` class so that all its children have a uniform behavior of processing an API's response.
    
    **IMPORTANT** You must call `super.handleResponse()` at the very end of your override to
    make sure that the `NSOperation` state flags are correctly updated.
    */
    open func handleResponse(_ someResponse: URLResponse?,
        _ someData: Data?,
        _ someError: Error?) {
            defer {
                self.closeOperation()
            }
    }
    
}
