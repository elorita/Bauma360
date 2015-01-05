//
//  RFID.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/14.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "RFID.h"

@implementation RFID

@dynamic generation, initializeDate, guid, printingSN, cid, initializeSN, statu, vendor;

+ (NSString *)parseClassName {
    return @"RFID";
}

@end
