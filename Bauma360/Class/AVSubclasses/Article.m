//
//  Article.m
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "Article.h"

@implementation Article

@dynamic title, source, date, summary, body, listImageFile, mainImageFile, headerImageFile;

+ (NSString *)parseClassName {
    return @"Article";
}

@end
