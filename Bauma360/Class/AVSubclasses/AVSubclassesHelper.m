//
//  AVSubclassesHelper.m
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "AVSubclassesHelper.h"
#import "Article.h"
#import "Resell.h"
#import "RFID.h"
#import "Product.h"
#import "ProductCategory.h"
#import "Customer.h"
#import "Vendor.h"

@implementation AVSubclassesHelper

+(void) RegisterSubclasses {
    [Article registerSubclass];
    [Resell registerSubclass];
    [ResellImage registerSubclass];
    [RFID registerSubclass];
    [Product registerSubclass];
    [Customer registerSubclass];
    [Vendor registerSubclass];
    [ProductCategory registerSubclass];
}

@end
