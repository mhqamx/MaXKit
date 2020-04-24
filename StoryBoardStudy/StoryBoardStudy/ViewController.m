//
//  ViewController.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2018/12/12.
//  Copyright © 2018 马霄. All rights reserved.
//

#define kDocumentDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define kIFlyVoiceDir [NSString stringWithFormat:@"%@/ifly/voice", kDocumentDir]

#import "ViewController.h"
#import "MXLoginViewController.h"
#import "MXChatTableViewController.h"
#import "MXImageViewController.h"
#import "MXBlockReviewViewController.h"
#import "MXViewT.h"
#import "MXTreeNode.h"
#import <AVFoundation/AVFoundation.h>
#import "MXDragonTigerViewController.h"
#import <MaxsFrameworkDemo/MaxObject.h>
#import <MaxsFrameworkDemo/MaxPrivate.h>

#import <PushKit/PushKit.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, privateMethodDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSString    *strongStr;
@property (nonatomic, copy)   NSString *cString;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, copy) void (^mxBlock)(NSString *);
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"home";
    [self configUI];
    [self configUINavigationBarItems];
    
    [self stringTest];
    
    NSArray *nums = @[@2, @5, @9, @11];
    for (int i = 0; i < nums.count; i++) {
        for (int j = 0; j < nums.count; j++) {
            if (([nums[i] intValue] + [nums[j] intValue]) == 7) {
                NSLog(@"i ---- %d, j ---- %d", i, j);
            }
        }
    }
    
    
    for (NSNumber *num1 in nums) {
        for (NSNumber *num2 in nums) {
            if ([num1 intValue] + [num2 intValue] == 7) {
                NSLog(@"num1 ---- %@, num2 ---- %@", num1, num2);
                NSInteger index1 = [nums indexOfObject:num1];
                NSInteger index2 = [nums indexOfObject:num2];
                NSLog(@"index1 --- %ld, index2 --- %ld", index1, index2);
            }
        }
    }
    
    
    MXViewT *tView = [[MXViewT alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - DEFAULTCELLHEIGHT*3, SCREEN_WIDTH, DEFAULTCELLHEIGHT*3)];
    tView.clickBlock = ^(NSInteger index) {
        NSLog(@"click Index --- %ld", index);
    };
    [self.view addSubview:tView];
//    MXTreeNode *currentNode = [MXTreeNode treeNodeAtIndex:2 inTree:rootNode];
    
    MXTreeNode *rootNode = [MXTreeNode creatTreeNodesWithValues:@[@1, @3, @5, @7, @9]];
    __block MXTreeNode *searchNode = [MXTreeNode new];
    [MXTreeNode levelTraverseTree:rootNode handler:^(MXTreeNode * _Nonnull treeNode) {
        if (treeNode.value == 7) {
            NSLog(@"%@", treeNode);
            searchNode = treeNode;
        }
    }];
    NSLog(@"search --- %ld", searchNode.value);

    MaxObject *model = [[MaxObject alloc] init];
    [model helloFrameWork];
    
    MaxPrivate *pModel = [[MaxPrivate alloc] init];
    pModel.delegate = self;

    // 目标:使block中的代码逻辑先行执行再执行外部的逻辑
//    BOOL checkStatus = [self semaphoreRunloopTest];
//    NSLog(@"checkStstus ----- %d", checkStatus);
    
    // 使用runloop切换主线程和子线程实现先执行block代码效果
    [self runloopTest];
//    NSLog(@" value --- %ld", currentNode.value);
}
// 使用信号量使block中代码块先执行
- (BOOL)semaphoreRunloopTest {
    __block BOOL checkStatus = NO;
    NSString *outStr = @"outStr";
    // 创建信号量为0的信号
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    self.mxBlock = ^(NSString *str) {
        NSLog(@"inside ----- %@", str);
        checkStatus = YES;
        NSLog(@"Bool_inside ---- %d", checkStatus);
        // 信号量加一
        dispatch_semaphore_signal(semaphore);
    };
    self.mxBlock(@"insideStr");
    // 等待信号量
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);


    NSLog(@"outside ===== %@", outStr);
    NSLog(@"Bool_outside ---- %d", checkStatus);
    return checkStatus;
}

// 使用CFRunLoop来实现完成先完成block中代码再执行外部
- (void)runloopTest {
    MXTreeNode *model = [[MXTreeNode alloc] init];
    NSString *outsideStr = @"outside";
    [model testSuccess:^(NSString * _Nonnull success) {
        NSString *sStr = @"sStr";
        NSLog(@"1.success ------ %@", sStr);
        NSLog(@"current_runloop_success ---- %@", [[NSRunLoop currentRunLoop] currentMode]);
        CFRunLoopStop(CFRunLoopGetMain());
        NSLog(@"current_runloop_success ---- %@", [[NSRunLoop currentRunLoop] currentMode]);
    } fail:^(NSString * _Nonnull fail) {
        NSString *fStr = @"fStr";
        NSLog(@"2.failure ---- %@", fStr);
        NSLog(@"current_runloop_failure ---- %@", [[NSRunLoop currentRunLoop] currentMode]);
        CFRunLoopStop(CFRunLoopGetMain());
        NSLog(@"current_runloop_failure ---- %@", [[NSRunLoop currentRunLoop] currentMode]);
    }];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    // 恢复runloop
//    CFRunLoopRun();
    NSLog(@"3.outside ---- %@", outsideStr);
    NSLog(@"current_runloop_outside ---- %p", [runLoop currentMode]);
}


- (void)stringTest {
    self.strongStr = @"strong String";
    self.cString = @"copy String";
    
    NSLog(@"s ---- %p\n c ---- %p", self.strongStr, self.cString);
    
    NSMutableString *mStr = [NSMutableString stringWithString:self.strongStr];
    mStr = @"mutableString".mutableCopy;
    NSLog(@"m ---- %@ p --- %p", mStr, mStr);
    NSString *tempStr = @"temp String";
    NSLog(@"t ----- %@, p ---- %p", tempStr, tempStr);
    
    NSString *aStr = [self.cString copy];
    self.cString = @"change c String";
    NSLog(@"aStr --- %@ --- %p\n cStr ---- %@ ---- %p", aStr, aStr, self.cString, self.cString);
    
    
//    s ---- 0x1029866f8
//    c ---- 0x102986718
//    2019-05-14 14:22:15.951351+0800 StoryBoardStudy[12195:162048] m ---- mutableString p --- 0x60000201de00
//    2019-05-14 14:24:27.666616+0800 StoryBoardStudy[12246:163794] t ----- temp String, p ---- 0x10bbb2798
//   mutableString 地址与全局变量的地址不同, 我再测试一个局部变量, 可见
}


- (void)configUINavigationBarItems {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"chart" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma private
- (void)configUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 150, SCREEN_WIDTH - 100*2, 40);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"login" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(100, 200, SCREEN_WIDTH - 100*2, 40);
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitle:@"img" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonOnClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self titleArr].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"mainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [self titleArr][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            MXChatTableViewController *VC = [[MXChatTableViewController alloc] init];
            VC = [VC instantiateViewControllerWithIdentifier:@"MXChatViewControllerID" withStoryboardName:@"chat"];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 1:{
            MXImageViewController *imageVC = [[MXImageViewController alloc] init];
            [self.navigationController pushViewController:imageVC animated:YES];
        }
            break;
        case 2: {
            MXLoginViewController *loginVC = [[MXLoginViewController alloc] init];
            loginVC = [loginVC instantiateViewControllerWithIdentifier:@"loginViewControllerID" withStoryboardName:@"Lanuch"];
            [self.navigationController presentViewController:loginVC animated:YES completion:nil];
        }
            break;
        case 3:{
            MXBlockReviewViewController *blockVC = [[MXBlockReviewViewController alloc] init];
            __weak __typeof(blockVC) weakVC = blockVC;
            blockVC.buttonBlock = ^{
                NSLog(@"MX----%s", __func__);
            };
            [self.navigationController pushViewController:blockVC animated:YES];
        }
            break;
        case 4:{
            // 两个button时并列 大于2之后是竖版显示
            // UIAlertActionStyleDestructive -> 红色按钮
            // UIAlertActionStyleDefault -> 普通
            // UIAlertActionStyleCancel -> 加深取消按钮
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"alertCancleAction");
            }];
            UIAlertAction *done = [UIAlertAction actionWithTitle:@"done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"alertDoneAction");
            }];
            UIAlertAction *third = [UIAlertAction actionWithTitle:@"third" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"test");
            }];
            [alertC addAction:cancle];
            [alertC addAction:done];
            [alertC addAction:third];
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentViewController:alertC animated:YES completion:nil];
            });
        }
            break;
        case 5:{
            NSArray *array = @[@"六", @"点", @"一", @"二"];
             // 片段音频合成一个完整音频文件
             NSMutableArray *dataArr = [NSMutableArray array];
             for (NSString *string in array) {
                 NSString *wayPath = [[NSBundle mainBundle] pathForResource:string ofType:@"wav"];
                 [dataArr addObject:[NSURL fileURLWithPath:wayPath]];
             }
            
             NSString *destPath = [kIFlyVoiceDir stringByAppendingString:@"finalVoice.m4a"];
             if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
                 [[NSFileManager defaultManager] removeItemAtPath:destPath error:nil];
             }
            
             [self audioMerge:dataArr destUrl:[NSURL fileURLWithPath:destPath]];
            
        }
            break;
        case 6:{
            MXDragonTigerViewController *betVC = [[MXDragonTigerViewController alloc] init];
            [self.navigationController pushViewController:betVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)audioMerge:(NSMutableArray *)dataSource destUrl:(NSURL *)destUrl{
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    // 开始时间
    CMTime beginTime = kCMTimeZero;
    // 设置音频合并音轨
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSError *error = nil;
    for (NSURL *sourceURL in dataSource) {
        //音频文件资源
        AVURLAsset  *audioAsset = [[AVURLAsset alloc] initWithURL:sourceURL options:nil];
        //需要合并的音频文件的区间
        CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
        // ofTrack 音频文件内容
        BOOL success = [compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:beginTime error:&error];
        
        if (!success) {
            NSLog(@"Error: %@",error);
        }
        beginTime = CMTimeAdd(beginTime, audioAsset.duration);
    }
    // presetName 与 outputFileType 要对应  导出合并的音频
    AVAssetExportSession *assetExportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    assetExportSession.outputURL = destUrl;
    assetExportSession.outputFileType = @"com.apple.m4a-audio";
    assetExportSession.shouldOptimizeForNetworkUse = YES;
    __weak typeof(self) weakSelf = self;
    [assetExportSession exportAsynchronouslyWithCompletionHandler:^{
        // 取出资源的URL
        NSURL *url = [NSURL fileURLWithPath:destUrl.absoluteString];
    
        // 创建播放器
        NSError *error = nil;
        weakSelf.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        // 准备播放
        [weakSelf.player prepareToPlay];
    
        // 播放歌曲
         [weakSelf.player play];
        NSLog(@"%s ----- %@", __func__, assetExportSession.error);
    }];
}

- (NSArray *)titleArr {
    return @[@"聊天", @"图片伸缩", @"登录", @"block", @"alert", @"语音合成", @"龙 or 虎"];
}

#pragma mark - 聊天界面
- (void)rightBtnOnClick {
    NSLog(@"%s", __func__);
    
    MXChatTableViewController *VC = [[MXChatTableViewController alloc] init];
    VC = [VC instantiateViewControllerWithIdentifier:@"MXChatViewControllerID" withStoryboardName:@"chat"];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 拉伸图片界面
- (void)buttonOnClick1 {
    NSLog(@"%s", __func__);

    MXImageViewController *imageVC = [[MXImageViewController alloc] init];
    [self.navigationController pushViewController:imageVC animated:YES];
}

#pragma mark - 登录界面
- (void)buttonOnClick {
    MXLoginViewController *loginVC = [[MXLoginViewController alloc] init];
    
    loginVC = [loginVC instantiateViewControllerWithIdentifier:@"loginViewControllerID" withStoryboardName:@"Lanuch"];
    [self.navigationController presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - privateMethodDelegate

- (void)privateMethod {
    NSLog(@"%s", __func__);
}


// 知识点总结归纳

// 1.H5怎么样回到原生, 也就是H5和原生用什么办法交互
// 我:使用iOS7之后提供的系统框架, jsCore, H5拟定方法名在原生进行事先, 还有一种就是用runtime的Swizzle黑魔法检索方法名, H5传递要执行的方法来实现
// 网站:
// 2.runtime使用场景
// 我:OC是面向对象的动态语言, 只有加载对象时才知道对象的类, 使用场景就是使用swizzing修改原生的方法, method方法都在一张hash表中, 使用runtime可以将只想方法的指针交换位置, 在load方法中也是runtime初次调用对象时使用, 在这个方法里可以对重要的数据进行存储等, 在加载完成后调用等. 还用来制作SDK, 一些埋点, 解析静态库的方法使用.
// 网:项目中用 Runtime 实现的功能 利用关联对象为分类增加伪属性 Objective-C 利用 Runtime 运行时变成一门动态语言，在开发过程中，使用 Runtime 相关 API 可以实现一些很强大的功能，这里我们简单讲到使用 Runtime 完成为分类增加伪属性、利用 Method SWizzling 来 Hook 方法、实现 NSCoding 自动归档解档、实现 KVO Block、多播委托。当然还可以实现更多的功能，比如字典模型之间的转换、页面无侵入埋点、监听 App 网络流量等等。
// 3.项目中遇到的难点怎么克服的:
// 我:之前项目做了一个二级分销类的功能由我来完成, 由于并发状态太多而且数据比较多页面很长所以使用UITableView可能不是很好, 主要是cell内部的重用问题和内部的刷新等. 所以使用一个个View放在一个大的UIScrowView上来分块处理数据, 而且不再使用后台返回的状态码来本地判断, 直接使用后台返回的cell名称或者类型直接注册显示, 省去了枚举中很多复杂的操作, 在cell懒加载中直接设置属性
//  使用runtime来监测供应商提供的SDK方法并改写方法
// 4.block为什么使用copy?
// 我block相当于C语言封装的一个结构体, block代码块中的代码是在栈区的, 因为可能需要手动管理所以要将block代码块内容copy到堆区管理.
// block的所有者如果有指针互相引用时会导致页面无法释方, 导致循环引用系统block住, 所以在代码块中使用的变量, 常亮和局部变量使用__block弱引用, 全局变量使用__weak __typeof()来弱引用, 当代码块使用_xxx类全局变量时, 因为没有自动创建getter和setter方法所以要用__strong引用方式提前释放
// 5.代理为什么要用weak
// 我:用retain可能导致空指针, 因为控制器要牵引代理, weak修饰不会导致引用计数增加




#pragma mark - UITableViewDelegate


@end
