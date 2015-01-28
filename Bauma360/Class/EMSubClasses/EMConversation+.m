//
//  EMConversation+.m
//  Bauma360
//
//  Created by TsaoLipeng on 15/1/12.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "EMConversation+.h"
#import <objc/runtime.h>

@interface EMConversation ()

@end

@implementation EMConversation (addproty)

static char strNicknameKey = 'n';
static char strPortraitKey = 'p';

- (NSString *)nickname {
    return objc_getAssociatedObject(self, &strNicknameKey);
}

- (void)setNickname:(NSString *)nickname {
    objc_setAssociatedObject(self, &strNicknameKey, nickname, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIImage *)headPortrait {
    return objc_getAssociatedObject(self, &strPortraitKey);
}

- (void) setHeadPortrait:(UIImage *)headPortrait {
    objc_setAssociatedObject(self, &strPortraitKey, headPortrait, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end