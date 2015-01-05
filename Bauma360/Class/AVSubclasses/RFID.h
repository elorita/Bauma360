//
//  RFID.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/14.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Vendor.h"

@interface RFID : AVObject<AVSubclassing>

@property (nonatomic) NSInteger generation;
@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSDate *initializeDate;
@property (nonatomic) NSInteger printingSN;
@property (nonatomic) NSInteger initializeSN;
@property (nonatomic) NSInteger statu;
@property (nonatomic, retain) Vendor *vendor;

@end
