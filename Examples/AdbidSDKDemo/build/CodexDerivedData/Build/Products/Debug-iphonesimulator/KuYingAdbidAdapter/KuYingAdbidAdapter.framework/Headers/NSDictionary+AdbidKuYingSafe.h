//
//  NSDictionary+LMSafe.h
//  AdbidSDK
//
//  Created by youzhadoubao on 2025/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary <__covariant KeyType, __covariant ObjectType>(AdbidKuYingSafe)

#pragma mark - safe getter

- (nullable ObjectType)adbid_objectForKey:(KeyType)aKey;

- (NSString *)adbid_stringForKey:(KeyType)aKey;

- (NSArray *)adbid_arrayForKey:(KeyType)aKey;

- (NSDictionary *)adbid_dictionaryForKey:(KeyType)aKey;

- (NSInteger)adbid_integerForKey:(KeyType)aKey;

- (CGFloat)adbid_floatForKey:(KeyType)aKey;

- (CGRect)adbid_rectForKey:(KeyType)aKey;

- (CGSize)adbid_sizeForKey:(KeyType)aKey;

- (CGPoint)adbid_pointForKey:(KeyType)aKey;

- (BOOL)adbid_boolForKey:(KeyType)key; 

- (NSNumber *)adbid_numberForKey:(KeyType)key;

- (NSArray<KeyType> *)adbid_allKeysForObject:(ObjectType)anObject;

- (BOOL)adbid_isEqualToDictionary:(NSDictionary<KeyType, ObjectType> *)otherDictionary;

@end

@interface NSMutableDictionary <KeyType, ObjectType>(AdbidKuYingSafe)

- (void)adbid_setObject:(ObjectType)anObject forKey:(KeyType)aKey;

- (void)adbid_removeObjectForKey:(KeyType)aKey;

- (void)adbid_addEntriesFromDictionary:(NSDictionary<KeyType, ObjectType> *)otherDictionary;

- (void)adbid_removeObjectsForKeys:(NSArray<KeyType> *)keyArray;

- (void)adbid_setDictionary:(NSDictionary<KeyType, ObjectType> *)otherDictionary;

- (id _Nullable)adbid_objectForKey:(id)key createIfNotExists:(id _Nonnull (^_Nullable)(void))createBlock;

+ (instancetype)safeDictionaryWithObject:(id)object forKey:(id<NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
