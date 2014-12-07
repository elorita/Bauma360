//
//  Resell.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/2.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Resell : AVObject<AVSubclassing>

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSDate *effectiveDate;
@property(nonatomic,copy) NSDate *expiryDate;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic,copy) NSString *body;
@property(nonatomic) NSInteger *price;
@property(nonatomic,retain) AVRelation *images;
@property(nonatomic) BOOL certified;
@property(nonatomic,retain) AVObject *certifiedInfo;

@end

#pragma 关联类定义

@interface ResellImage : AVObject<AVSubclassing>

@property(nonatomic, retain) AVFile *image;
@property(nonatomic) NSInteger order;

@end
