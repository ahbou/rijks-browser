import Foundation

public class Log {
    public class func info(
        _ object: Any,
        functionName: String = #function,
        fileNameWithPath: NSString = #file,
        lineNumber: Int = #line
    ) {
        #if DEBUG
        let output = "⭐️ \(Date()) [\(fileNameWithPath.lastPathComponent), \(functionName), line \(lineNumber)] \(object)"
        print(output)
        #endif
    }

    public class func error(
        _ error: Any,
        functionName: String = #function,
        fileNameWithPath: String = #file,
        lineNumber: Int = #line
    ) {
        #if DEBUG
        let output = "‼️ \(Date()) [\(functionName), line \(lineNumber)] \(error)"
        print(output)
        #endif
    }
}

