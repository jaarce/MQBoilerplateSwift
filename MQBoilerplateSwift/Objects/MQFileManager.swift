//
//  MQFileManager.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/16/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

open class MQFileManager {
    
    /**
    Returns the URL of a file in /Document.
    */
    open class func URLForFileName(_ fileName: String) -> URL? {
        return self.URLForFileName(fileName, inFolder: .documentDirectory)
    }
    
    /**
    Returns the URL for a file in a given system directory.
    */
    open class func URLForFileName(_ fileName: String, inFolder folder: FileManager.SearchPathDirectory) -> URL? {
        if let systemDirectory = self.URLForSystemFolder(folder) {
            return systemDirectory.appendingPathComponent(fileName)
        }
        return nil
    }
    
    /**
    Returns the URL for a system folder in the app's sandbox.
    */
    open class func URLForSystemFolder(_ folder: FileManager.SearchPathDirectory) -> URL? {
        let fileManager = FileManager.default
        let URLs = fileManager.urls(for: folder, in: .userDomainMask)
        
        if let lastObject: AnyObject = URLs.last as AnyObject? {
            if let  directoryURL = lastObject as? URL {
                return directoryURL
            }
        }
        return nil
    }
    
    /**
    Convenience method for checking whether a file exists in /Document.
    */
    open class func findsFileWithName(_ fileName: String) -> Bool {
        return self.findsFileWithName(fileName, inFolder: .documentDirectory)
    }
    
    open class func findsFileWithName(_ fileName: String, inFolder folder: FileManager.SearchPathDirectory) -> Bool {
        if let filePath = self.URLForFileName(fileName, inFolder: folder) {
            return FileManager.default.fileExists(atPath: filePath.path)
        }
        return false
    }
    
    open class func findsFileInURL(_ fileURL: URL) -> Bool {
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
//    open class func writeValue<T: MQArchivableValueType>(_ value: T, toFile fileName: String, inFolder folder: FileManager.SearchPathDirectory = .documentDirectory, error: NSErrorPointer?) {
//        if let fileURL = self.URLForFileName(fileName, inFolder: folder),
//            let path = fileURL.path {
//                let dictionary = value.archiveDictionary()
//                if NSKeyedArchiver.archiveRootObject(dictionary, toFile: path) == false {
//                    if error != nil {
//                        error??.pointee = MQError("Archiving value \(value) failed.")
//                    }
//                    return
//                }
//        } else {
//            if error != nil {
//                error??.pointee = MQError("Cannot build a file URL to file name '\(fileName)' in '\(folder)'.")
//            }
//            return
//        }
//    }
//    
//    open class func writeValue(_ value: AnyObject, toFile fileName: String, inFolder folder: FileManager.SearchPathDirectory = .documentDirectory, error: NSErrorPointer?) {
//        if let fileURL = self.URLForFileName(fileName, inFolder: folder),
//            let path = fileURL.path {
//                if NSKeyedArchiver.archiveRootObject(value, toFile: path) == false {
//                    if error != nil {
//                        error??.pointee = MQError("Cannot write value \(value) to file.")
//                    }
//                    return
//                }
//        } else {
//            error??.pointee = MQError("Cannot build a file URL to file name '\(fileName)' in '\(folder)'.")
//        }
//    }
    
//    open class func valueAtFile<T: MQArchivableValueType>(_ fileName: String, inFolder folder: FileManager.SearchPathDirectory = .documentDirectory) -> T? {
//        if let fileURL = self.URLForFileName(fileName, inFolder: folder),
//            let path = fileURL.path,
//            let dictionary = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [String : AnyObject] {
//                return T(archiveDictionary: dictionary)
//        }
//        return nil
//    }
//    
//    open class func valueAtFile<T>(_ fileName: String, inFolder folder: FileManager.SearchPathDirectory = .documentDirectory) -> T? {
//        if let fileURL = self.URLForFileName(fileName, inFolder: folder),
//            let path = fileURL.path,
//            let object = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? T {
//                return object
//        }
//        return nil
//    }
//    
//    open class func deleteValueAtFile(_ fileName: String, inFolder folder: FileManager.SearchPathDirectory = .documentDirectory, error: NSErrorPointer) {
//        if let fileURL = self.URLForFileName(fileName, inFolder: folder) {
//            if self.findsFileInURL(fileURL) {
//                do {
//                    try FileManager.default.removeItem(at: fileURL)
//                } catch let error1 as NSError {
//                    error?.pointee = error1
//                }
//            }
//        }
//    }
//    
}

// FIXME: Swift 2.0
/*public extension MQFileManager {

    public class func writeValue<T: MQArchivableValueType>(value: T, toFile fileName: String, inFolder folder: NSSearchPathDirectory = .DocumentDirectory) throws {
        guard let fileURL = self.URLForFileName(fileName, inFolder: folder),
            let path = fileURL.path else {
                throw MQError("Cannot build a file URL to file name '\(fileName)' in '\(folder)'.")
        }
        
        let dictionary = value.archiveDictionary()
        if NSKeyedArchiver.archiveRootObject(dictionary, toFile: path) == false {
            throw MQError("Archiving value \(value) failed.")
        }
    }
    
    public class func writeValue(value: AnyObject, toFile fileName: String, inFolder folder: NSSearchPathDirectory = .DocumentDirectory) throws {
        guard let fileURL = self.URLForFileName(fileName, inFolder: folder),
            let path = fileURL.path else {
                throw MQError("Cannot build a file URL to file name '\(fileName)' in '\(folder)'.")
        }
        
        if NSKeyedArchiver.archiveRootObject(value, toFile: path) == false {
            throw MQError("Cannot write value \(value) to file.")
        }
    }
    
    public class func valueAtFile<T: MQArchivableValueType>(fileName: String, inFolder folder: NSSearchPathDirectory = .DocumentDirectory) -> T? {
        guard let fileURL = self.URLForFileName(fileName, inFolder: folder),
            let path = fileURL.path,
            let dictionary = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [String : AnyObject] else {
                return nil
        }
        
        return T(archiveDictionary: dictionary)
    }
    
    public class func valueAtFile<T>(fileName: String, inFolder folder: NSSearchPathDirectory = .DocumentDirectory) -> T? {
        guard let fileURL = self.URLForFileName(fileName, inFolder: folder),
            let path = fileURL.path,
            let object = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? T else {
                return nil
        }
        
        return object
    }
    
    public class func deleteValueAtFile(fileName: String, inFolder folder: NSSearchPathDirectory = .DocumentDirectory) throws {
        guard let fileURL = self.URLForFileName(fileName, inFolder: folder) else {
                return
        }
        
        if self.findsFileInURL(fileURL) {
            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
        }
    }
    
}
*/
