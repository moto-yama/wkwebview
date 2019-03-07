//
//  WebViewController.h
//  wkwebview
//
//  Created by Yuichiro Motoyama on 2019/03/07.
//  Copyright © 2019 moto-yama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *safeView;
@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UIScrollView *scView;

- (IBAction)closeClick:(UIButton *)sender;
- (IBAction)homeClick:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
