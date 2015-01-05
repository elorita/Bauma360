//
//  Product.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/16.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Customer.h"
#import "RFID.h"
#import "ProductCategory.h"

@interface Product : AVObject<AVSubclassing>

@property (nonatomic, copy) NSString * productSn;
@property (nonatomic, copy) NSString * categoryName;
@property (nonatomic, retain) Customer *customer;
@property (nonatomic, copy) NSDate *productDate;
@property (nonatomic, copy) NSDate *factoryDate;
@property (nonatomic) NSInteger statu;
@property (nonatomic, retain) Vendor *vendor;
@property (nonatomic, retain) RFID *rfid;
@property (nonatomic, retain) ProductCategory *category;

@end
