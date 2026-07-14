//
//  LMAdCustomAdapterCommonHeader.h
//  Pods
//
//  Created by mark zhang  on 2026/1/3.
//

#ifndef UBIXAdAdapterCommonHeader_h
#define UBIXAdAdapterCommonHeader_h

#import <AdbidSDK/AdbidSDK.h>
#import "NSDictionary+AdbidUBixSafe.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UbiXAdSDK/UbiXAdSDK.h>
#import "UBiXAdbidTool.h"

/**
 数组防空判断
 */
#define isUBixAdapterArrEmpty(array) (array == nil || array == NULL || (![array isKindOfClass:[NSArray class]]) || array.count == 0)

/**
 字典防空判断
 */
#define isUBixAdapterDictEmpty(dict) (dict == nil || dict == NULL || (![dict isKindOfClass:[NSDictionary class]]) || dict.count == 0)

/**
 字符串防空判断
 */
#define isUBixAdapterStrEmpty(string) (string == nil || string == NULL || (![string isKindOfClass:[NSString class]]) || ([string isEqual:@""]) || [string isEqualToString:@""] || [string isEqualToString:@" "] || ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) || ([string respondsToSelector:@selector(length)] && [(NSData *)string length] == 0))

#endif /* LMAdCustomAdapterCommonHeader_h */
