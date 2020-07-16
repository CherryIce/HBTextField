//
//  ViewController.m
//  CopyToMyApp
//
//  Created by Mr.Zhu on 03/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"

#define UserInfoKey @"UserInfoKey"

@interface ViewController ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic,strong)UIDocumentInteractionController * document;

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileNotification:) name:@"FileNotification" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //视频 音频可以用wkwebview打开
    
    NSUserDefaults *shareDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.share.entitlements"];
    NSDictionary * userDict = [shareDefaults objectForKey:UserInfoKey];
    if (userDict) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:UIBarButtonItemStyleDone target:self action:@selector(loginOutApp)];
    }else{
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(loginInApp)];
    }
}

- (void)fileNotification:(NSNotification *)notifcation {
    NSDictionary *info = notifcation.userInfo;
    // fileName是文件名称、filePath是文件存储在本地的路径
    // jfkdfj123a.pdf
    NSString *fileName = [info objectForKey:@"fileName"];
    // /private/var/mobile/Containers/Data/Application/83643509-E90E-40A6-92EA-47A44B40CBBF/Documents/Inbox/jfkdfj123a.pdf
    NSString *filePath = [info objectForKey:@"filePath"];

    NSLog(@"\n fileName=%@ \n filePath=%@", fileName, filePath);
    
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:fileName message:filePath preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self finallFilePathWithFilePath:filePath index:0];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"other open" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self finallFilePathWithFilePath:filePath index:1];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) finallFilePathWithFilePath:(NSString * )fileUrl index:(NSInteger) index{
    //NSDocumentDirectory
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [[paths1 objectAtIndex:0] stringByAppendingPathComponent:fileUrl.lastPathComponent];
    NSError*error =nil;
    NSFileManager * fileManage = [NSFileManager defaultManager];
    BOOL isCopySuccess  = [fileManage fileExistsAtPath:cachesDir];
    if (!isCopySuccess) {
        isCopySuccess = [fileManage copyItemAtPath:fileUrl toPath:cachesDir error:&error];
    }
    NSLog(@"\n\n***********\n copyPath: \n %@ \n\n***********\n targetPath: \n %@ \n\n***********\n error: \n %@ ",fileUrl,cachesDir,error);
    
    if (isCopySuccess) {
        self.document = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:cachesDir]];
        self.document.delegate = self;
        //self.document.UTI = @"com.microsoft.word.doc";
        if (index == 0) {
            // 用户预览文件
            bool canPreView = [self.document presentPreviewAnimated:YES];
            if(!canPreView) {NSLog(@"无法预览");}
        }else{
            // 用户不预览文件直接分享
            BOOL canOpen = [self.document presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
            if(!canOpen) {NSLog(@"沒有程序可以打开选中的文件");}
        }
    }
}

-(UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller{
    return
    self;
}

-(UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return
    self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return
    self.view.frame;
}

//点击预览窗口的“Done”(完成)按钮时调用

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)controller {

}

// 文件分享面板弹出的时候调用

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController*)controller{
    NSLog(@"WillPresentOpenInMenu");
}

// 当选择一个文件分享App的时候调用
- (void)documentInteractionController:(UIDocumentInteractionController*)controller willBeginSendingToApplication:(nullable NSString*)application{
    NSLog(@"begin send : %@", application);
}

// 弹框消失的时候走的方法
- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController*)controller{
    NSLog(@"dissMiss");
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 登录、登出
- (void) loginInApp {
    NSUserDefaults *shareDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.share.entitlements"];
    NSDictionary *shareDic = @{@"userId" : @"lc001",@"token" : @"now",@"friend_img": @"friend",@"circle_img":@"circle"};
    [shareDefaults setObject:shareDic forKey:UserInfoKey];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:UIBarButtonItemStyleDone target:self action:@selector(loginOutApp)];
}

- (void) loginOutApp {
    NSUserDefaults *shareDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.share.entitlements"];
    [shareDefaults removeObjectForKey:UserInfoKey];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(loginInApp)];
}


@end
