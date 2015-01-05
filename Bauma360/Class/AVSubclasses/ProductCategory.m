//
//  ProductCategory.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/16.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "ProductCategory.h"

@implementation ProductCategory

@synthesize parent, categoryName, fullName, level, tagGeneration, image, width, length, weight, height, wmmtAdapted;

+ (NSString *)parseClassName {
    return @"ProductCategory";
}

@end
