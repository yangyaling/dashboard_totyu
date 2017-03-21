//
//  LGFNullCheck.m
//  DashBoard
//
//  Created by totyu3 on 17/3/9.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "LGFNullCheck.h"

@implementation LGFNullCheck

/**
 去除nsnull
 */
+(id)CheckNSNullObject:(id)nullobject{
    if ([nullobject isKindOfClass:[NSDictionary class]]||[nullobject isKindOfClass:[NSMutableDictionary class]]) {
        return [self CheckDictionaryNSnull:nullobject];
    } else {
        return [self CheckArrayNSnull:nullobject];
    }
}
/**
 去除字典内nsnull
 */
+(NSMutableDictionary*)CheckDictionaryNSnull:(id)nulldict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:nulldict];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]||[obj isKindOfClass:[NSMutableDictionary class]]) {
            [dict setObject:[self CheckDictionaryNSnull:obj] forKey:key];
        }else if ([obj isKindOfClass:[NSArray class]]||[obj isKindOfClass:[NSMutableArray class]]) {
            [dict setObject:[self CheckArrayNSnull:obj] forKey:key];
        } else {
            if (obj == [NSNull null]) {
                obj = @"";
            } else {
                obj = [NSString stringWithFormat:@"%@",obj];
            }
            [dict setObject:obj forKey:key];
        }
    }];
    return dict;
}
/**
 去除数组内nsnull
 */
+(NSMutableArray*)CheckArrayNSnull:(id)nullarray{    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:nullarray];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]||[obj isKindOfClass:[NSMutableDictionary class]]) {
            [arr replaceObjectAtIndex:idx withObject:[self CheckDictionaryNSnull:obj]];
        }else if ([obj isKindOfClass:[NSArray class]]||[obj isKindOfClass:[NSMutableArray class]]) {
            [arr replaceObjectAtIndex:idx withObject:[self CheckArrayNSnull:obj]];
        } else {
            if (obj == [NSNull null]) {
                obj = @"";
            } else {
                obj = [NSString stringWithFormat:@"%@",obj];
            }
            [arr replaceObjectAtIndex:idx withObject:obj];
        }
    }];
    return arr;
}
@end
