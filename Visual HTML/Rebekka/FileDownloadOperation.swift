//
//  FileDownloadOperation.swift
//  Rebekka
//
//  Created by Constantine Fry on 25/05/15.
//  Copyright (c) 2015 Constantine Fry. All rights reserved.
//

import Foundation

/** Operation for downloading a file from FTP server. */
internal class FileDownloadOperation: ReadStreamOperation {
    
    private var fileHandle: FileHandle?
    var fileURL: URL?
    var progressHandler: DownloadProgressHandler?
    
    func setFilePath(url:URL){
        self.fileURL = url
    }
    
    override func start() {
        
       // let filePath = (NSTemporaryDirectory() as NSString).appendingPathComponent(path ?? UUID().uuidString)
       // self.fileURL = URL(fileURLWithPath: filePath)
       
        print("atURL\(self.fileURL)")
        do {
            FileManager.default.createFile(atPath: (self.fileURL?.path)!, contents: nil, attributes: nil)
            try Data().write(to: self.fileURL!, options: NSData.WritingOptions.atomic)
            self.fileHandle = try FileHandle(forWritingTo: self.fileURL!)
            self.startOperationWithStream(self.readStream)
        } catch let error as NSError {
            self.error = error
            self.finishOperation()
        }
    }
    
    override func streamEventEnd(_ aStream: Stream) -> (Bool, NSError?) {
        self.fileHandle?.closeFile()
        return (true, nil)
    }
    
    override func streamEventError(_ aStream: Stream) {
        super.streamEventError(aStream)
        self.fileHandle?.closeFile()
        if self.fileURL != nil {
            do {
                try FileManager.default.removeItem(at: self.fileURL!)
            } catch _ {
            }
        }
        self.fileURL = nil
    }
    
    override func streamEventHasBytes(_ aStream: Stream) -> (Bool, NSError?) {
        let totalBytesSize = aStream.property(forKey: Stream.PropertyKey(rawValue: kCFStreamPropertyFTPResourceSize as String)) as? Int
        var downloadedBytes: Int = 0
        if let inputStream = aStream as? InputStream {
            var parsetBytes: Int = 0
            repeat {
                parsetBytes = inputStream.read(self.temporaryBuffer, maxLength: 65536)
                downloadedBytes += parsetBytes
                if totalBytesSize != nil{
                progressHandler?(Float(downloadedBytes) / Float(totalBytesSize!))
                }
                if parsetBytes > 0 {
                    autoreleasepool {
                        let data = Data(bytes: UnsafePointer<UInt8>(self.temporaryBuffer), count: parsetBytes)
                        self.fileHandle!.write(data)
                        print("FTPManager: DownLoadData\(NSString(data: data, encoding: String.Encoding.utf8.rawValue))")
                    }
                }
            } while (parsetBytes > 0)
        }
        return (true, nil)
    }
}

