//
//  HomeVC.h
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableCellProtocols.h"

@interface HomeVC : UIViewController<CustomTableCellDelegate>

-(void)showArticle:(Article *)article;

@end
