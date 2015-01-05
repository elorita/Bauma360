//
//  Customer.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/16.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Vendor.h"

@interface Customer : AVObject<AVSubclassing>

@property (nonatomic, copy) NSString * customerName;
@property (nonatomic, copy) NSString * telNo;
@property (nonatomic, retain) Vendor *vendor;

@end
