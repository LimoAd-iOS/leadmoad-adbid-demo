//
//  TimeUtil.m
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/9.
//

#import "TimeUtil.h"

@implementation TimeUtil
+ (NSArray *)times {
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    
    NSString *timeString = [formatter stringFromDate:now];
    int64_t timestamp = (int64_t)(now.timeIntervalSince1970 * 1000);
    
    return @[timeString, @(timestamp)];
}
@end
