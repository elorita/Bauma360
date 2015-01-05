//
//  Product.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/16.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "Product.h"

@implementation Product

@synthesize productSn, categoryName, customer, productDate, factoryDate, statu, rfid, vendor, category;

+ (NSString *)parseClassName {
    return @"Product";
}

@end
