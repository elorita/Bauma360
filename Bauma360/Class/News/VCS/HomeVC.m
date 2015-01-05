//
//  HomeVC.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

#import "HomeVC.h"
#import "HomeView.h"
#import "Macros.h"
#import "Article.h"
#import "RSArticle.h"
#import "RSReadingBoard.h"
#import "AddFriendViewController.h"
#import "SimuCertifiedViewController.h"
#import "ImgShowViewController.h"
#import "PassValueDelegate.h"
#import "QRScanViewController.h"
#import "ShowProductInfoViewController.h"
#import "ZBarSDK.h"
#import "ShowProductInfoViewController.h"
#import "ChatViewController.h"
#import "LoginViewController.h"

@interface HomeVC () <PassValueDelegate>
{
    HomeView *mHomeView;
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}

@property (nonatomic, strong) UIImageView * line;//二维码扫描的往复线

@end

@implementation HomeVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
    if (self != nil) {
        [self initCommonData];
        [self initTopNavBar];
    }
    return self;
}

//主要用来方向改变后重新改变布局
- (void) setLayout: (BOOL) aPortait {

    [self setViewFrame];
}

//重载导航条
-(void)initTopNavBar{
    self.title = @"首页";
    //self.navigationItem.leftBarButtonItem = Nil;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;

}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad{
    [self initView];
}

//初始化数据
-(void)initCommonData{
    
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mHomeView release];
    [super dealloc];
}
#endif

// 初始View
- (void) initView {
    
    if (IS_IOS7) {
        self.edgesForExtendedLayout =UIRectEdgeNone ;
    }
    //contentView大小设置
    int vWidth = (int)([UIScreen mainScreen].bounds.size.width);
    int vHeight = (int)([UIScreen mainScreen].bounds.size.height);
    //contentView大小设置
    
    CGRect vViewRect = CGRectMake(0, 0, vWidth, vHeight -44 -40);
    UIView *vContentView = [[UIView alloc] initWithFrame:vViewRect];
    if (mHomeView == nil) {
        mHomeView = [[HomeView alloc] initWithFrame:vContentView.frame controller:self];
    }
    [vContentView addSubview:mHomeView];
    
    self.view = vContentView;
    
    [self setViewFrame];
}

//设置View方向
-(void) setViewFrame{
 
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//------------------------------------------------

-(void)showArticle:(Article *)article{
    RSArticle *rsArticle = [RSArticle new];
    rsArticle.image = [UIImage imageWithData:[article.mainImageFile getData]];
    rsArticle.title = article.title;
    rsArticle.source = article.source;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy年M月d日 H点m分"];
    rsArticle.date = [formatter stringFromDate:article.date];
    rsArticle.body = article.body;
    rsArticle.color = [UIColor redColor];
    rsArticle.clips = @[[UIImage imageNamed:@"clip0"],
                      [UIImage imageNamed:@"clip1"],
                      [UIImage imageNamed:@"clip2"]];
    
    RSReadingBoard *board = [RSReadingBoard board];
    board.article = rsArticle;

    [self.navigationController pushViewController:board animated:YES];
}

#pragma ResellOuterDelegate

-(void)showResell:(Resell *)resell{
}

-(void)showCertificate:(Resell *)resell{
    SimuCertifiedViewController *controller = [[SimuCertifiedViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)callOwner:(AVUser *)owner{
    AVUser *curUser = [AVUser currentUser];
    NSDictionary *easeLoginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    if (curUser != nil && easeLoginInfo != nil) {
        if (curUser.username == owner.username) {
            TTAlert(@"您不能向自己发送消息!");
        } else {
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:owner.username];
            chatVC.title = [owner objectForKey:@"nickname"];
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma
- (void)collectionView:(PPImageScrollingCellView *)collectionView didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath onImages:(NSArray *)images{
    ImgShowViewController *imgShow = [[ImgShowViewController alloc] initWithSourceData:images withIndex:indexPath.row];
    //[self.navigationController presentViewController:imgShow animated:YES completion:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imgShow];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - PassValueDelegate,及二维码扫描相关代码
-(void)setupCamera{
    if(IOS7)
    {
        QRScanViewController * rt = [[QRScanViewController alloc]init];
        rt.passValueDelegate = self;
        [self presentViewController:rt animated:NO completion:^{
            
        }];
        
    }
    else
    {
        [self scanBtnAction];
    }
}

-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self presentViewController:reader animated:YES completion:^{
        
    }];
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        
        
        NSLog(@"%@",result);
        
    }];
}

-(void)passValue:(NSString *)value{
    NSString *oid;
    NSRange rangeGuid = [value rangeOfString:@"GUID="];
    NSRange rangeOid = [value rangeOfString:@"OBJECTID="];
    
    if (rangeOid.length > 0)
        oid = [value substringFromIndex:NSMaxRange(rangeOid)];
    else if (rangeGuid.length > 0)//ID不是Guid，则为ObjectId
        oid = [value substringFromIndex:NSMaxRange(rangeGuid)];
    else
        oid = @"";
    
    
    ShowProductInfoViewController* spi = [ShowProductInfoViewController new];
    if ([oid length] > 0){
        [spi setProductID:oid];
    } else {
        [spi showWarning];
    }
    [self presentViewController:spi animated:YES completion:^{}];
}


@end
