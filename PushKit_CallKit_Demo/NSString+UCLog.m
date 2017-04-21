//
//  NSString+UCLog.m
//  UCS_IM_Demo
//
//  Created by Barry on 2017/4/10.
//  Copyright © 2017年 Barry. All rights reserved.
//

#import "NSString+UCLog.h"

@implementation NSString (UCLog)

- (void)saveTolog{
    
    NSString *log = [NSString stringWithFormat:@"\n%@", self];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath=[documentsDirectory stringByAppendingPathComponent:@"OTTDemoLog.txt"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //如果文件存在并且它的大小大于1M，则删除并且重新创建一个
        long long filesizes  = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        if ((filesizes/(1024.0*1024.0))>1) {
            //删除当前文件
            [fileManager removeItemAtPath:filePath error:nil];
            //重新创建一个文件
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        }
        NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
        //找到并定位到outFile的末尾位置(在此后追加文件)
        [outFile seekToEndOfFile];
        [outFile writeData:[log dataUsingEncoding:NSUTF8StringEncoding]];
        //关闭读写文件
        [outFile closeFile];
    }else{
        // 如果文件不存在 则创建并且将文件写入
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        [log writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}


@end
