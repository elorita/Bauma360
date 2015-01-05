//
//  Vendor.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/16.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Vendor : AVObject<AVSubclassing>

@property (nonatomic, copy) NSString * vendorCode;
@property (nonatomic, copy) NSString * vendorName;

@end
