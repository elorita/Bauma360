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

@implementation AVSubclassesHelper

+(void) RegisterSubclasses {
    [Article registerSubclass];
    [Resell registerSubclass];
    [ResellImage registerSubclass];
}

@end
