# ICTraceLog

[![CI Status](http://img.shields.io/travis/aintivanc@icloud.com/ICTraceLog.svg?style=flat)](https://travis-ci.org/aintivanc@icloud.com/ICTraceLog)
[![Version](https://img.shields.io/cocoapods/v/ICTraceLog.svg?style=flat)](http://cocoapods.org/pods/ICTraceLog)
[![License](https://img.shields.io/cocoapods/l/ICTraceLog.svg?style=flat)](http://cocoapods.org/pods/ICTraceLog)
[![Platform](https://img.shields.io/cocoapods/p/ICTraceLog.svg?style=flat)](http://cocoapods.org/pods/ICTraceLog)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

ICTraceLog is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ICTraceLog"
```

## Usage

Setup you own log

```objective-c
#define MY_LOAD_IDENTIFIER @"Chocolate"

ICTraceLogManager *manager = [DEFAULT_TRACE_LOG_CENTER registerTraceIdentifier:MY_LOAD_IDENTIFIER];
    
// If need to save to disk
NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.log"];
ICTraceLogIOWriterFile *fileWriter = [[ICTraceLogIOWriterFile alloc] initWithFilePath:path];
[manager addIOWriter:fileWriter];
```

Try to log something

```c
    TLOG_DEBUG(MY_LOAD_IDENTIFIER, @"log enabled to disk: %@\n", path);
    TLOG_INFO(MY_LOAD_IDENTIFIER, @"Just info");
    TLOG_WARN(MY_LOAD_IDENTIFIER, @"This is a warning");
    TLOG_ERROR(MY_LOAD_IDENTIFIER, @"Error will show selector & line number");
    TLOG_FATAL(MY_LOAD_IDENTIFIER, @"Fatal will do the same, And you won't see the next log");

    [manager resetLoggingLevelWithString:@"WARN|ERROR|FATAL"];
   
    TLOG_DEBUG(MY_LOAD_IDENTIFIER, @"You can't see me");
    TLOG_INFO(MY_LOAD_IDENTIFIER, @"and me");
```

Result will be

```
  [Chocolate]  2017-05-12 15:51:19, 2819  [DEBUG] log enabled to disk: /Users/_ivanc/Library/Developer/CoreSimulator/Devices/B97A9304-14FA-4556-8734-E344A8EC2A11/data/Containers/Data/Application/026688AC-9344-4EBE-B1ED-4BAD49298332/Documents/test.log
  
  [Chocolate]  2017-05-12 15:51:19, 2819  [INFO] Just info  
  [Chocolate]  2017-05-12 15:51:19, 2819  [ERROR] Error will show selector & line number 
 ****** -[ICViewController viewDidLoad] LINE:36 ****** 
 
  [Chocolate]  2017-05-12 15:51:19, 2819  [FATAL] Fatal will do the same, And you won't see the next log 
 ****** -[ICViewController viewDidLoad] LINE:37 ****** 

```

## Author

_ivanC

## License

ICTraceLog is available under the MIT license. See the LICENSE file for more info.
