//
//  Resell.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/2.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "Resell.h"

@implementation Resell

@dynamic title, effectiveDate, expiryDate, summary, body, images, certified, certifiedInfo, price;

+ (NSString *)parseClassName {
    return @"Resell";
}

@end


@implementation ResellImage

@dynamic image, order;

+ (NSString *)parseClassName {
    return @"ResellImage";
}

@end