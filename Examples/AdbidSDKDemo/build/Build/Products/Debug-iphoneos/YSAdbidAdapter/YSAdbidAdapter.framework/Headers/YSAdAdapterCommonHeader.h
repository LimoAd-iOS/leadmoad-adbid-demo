//
//  YSAdCustomAdapterCommonHeader.h
//  Pods
//
//  Created by mark zhang  on 2026/1/3.
//

#ifndef YSAdAdapterCommonHeader_h
#define YSAdAdapterCommonHeader_h

#import <AdbidSDK/AdbidSDK.h>
#import "NSDictionary+AdbidYSSafe.h"
#import <objc/runtime.h>
#import <objc/message.h>

/**
 数组防空判断
 */
#define isYSAdapterArrEmpty(array) (array == nil || array == NULL || (![array isKindOfClass:[NSArray class]]) || array.count == 0)

/**
 字典防空判断
 */
#define isYSAdapterDictEmpty(dict) (dict == nil || dict == NULL || (![dict isKindOfClass:[NSDictionary class]]) || dict.count == 0)

/**
 字符串防空判断
 */
#define isYSAdapterStrEmpty(string) (string == nil || string == NULL || (![string isKindOfClass:[NSString class]]) || ([string isEqual:@""]) || [string isEqualToString:@""] || [string isEqualToString:@" "] || ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) || ([string respondsToSelector:@selector(length)] && [(NSData *)string length] == 0))

#ifndef dispatch_main_async_adbidSafeQueue
#define dispatch_main_async_adbidSafeQueue(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

#endif /* FunLinkAdCustomAdapterCommonHeader_h */
