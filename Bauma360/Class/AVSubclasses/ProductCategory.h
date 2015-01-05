//
//  ProductCategory.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/16.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface ProductCategory : AVObject<AVSubclassing>

@property (nonatomic, retain) ProductCategory *parent;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger tagGeneration;
@property (nonatomic, retain) AVFile *image;
@property (nonatomic) NSInteger weight;
@property (nonatomic) NSInteger length;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic, retain) NSArray *wmmtAdapted;

@end
