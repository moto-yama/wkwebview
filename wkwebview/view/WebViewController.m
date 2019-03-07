//
//  WebViewController.m
//  wkwebview
//
//  Created by Yuichiro Motoyama on 2019/03/07.
//  Copyright © 2019 moto-yama. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    NSURL   *nextURL;
    Boolean naviFlag;
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // WKWebView インスタンスの生成
    self.webView = [[WKWebView alloc] initWithFrame:self.scView.frame];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.safeView addSubview:self.webView];

    // refrech
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    self.webView.scrollView.refreshControl = refreshControl;
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    // scrollview
    self.scView.hidden = YES;
    self.webView.hidden = YES;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 初回画面表示時にIntialURLで指定した Web ページを読み込む
    NSString *home = [[NSUserDefaults standardUserDefaults] stringForKey:@"home"];
    if (home.length == 0){
        home = @"http://google.co.jp";
    }
    
    nextURL = [NSURL URLWithString:home];
    NSURLRequest *request = [NSURLRequest requestWithURL:nextURL];
    [self.webView loadRequest:request];

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.webView.frame = self.scView.frame;
    self.webView.hidden = false;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - wkwebview
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    
    // basic認証
    NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:[nextURL user]
                                                               password:[nextURL password]
                                                            persistence:NSURLCredentialPersistenceNone];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    
    // iTunes: アプリのリンクなど
    if ([url.absoluteString rangeOfString:@"//itunes.apple.com/"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // mailto
    else if ([url.absoluteString rangeOfString:@"mailto:"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // tel
    else if ([url.absoluteString rangeOfString:@"tel:"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //読み込み続行
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self alert_load_error:error];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self alert_load_error:error];
}

- (void)alert_load_error:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *dic = error.userInfo;
    NSString *str_msg = [dic objectForKey:@"NSLocalizedDescription"];
    
    if (str_msg.length != 0){
        NSLog(@"webview log: %@", str_msg);
    }
}

#pragma mark - refreshControl
- (void)onRefresh:(UIRefreshControl*)refreshControl
{
    // 更新開始
    [refreshControl beginRefreshing];
    
    // 更新処理をここに記述
    [self.webView reload];
    [self naviShow];
    
    // 更新終了
    [refreshControl endRefreshing];
}

- (void)naviShow {
    [UIView animateWithDuration:0.4 animations:^{
        self.naviView.frame = CGRectMake(0, 0, self.scView.frame.size.width, 44);
        
        CGRect rect = self.scView.frame;
        rect.origin.y += 44;
        rect.size.height -= 44;
        self.webView.frame = rect;
    }];
    naviFlag = NO;
}

- (void)naviHide {
    [UIView animateWithDuration:0.4 animations:^{
        self.naviView.frame = CGRectMake(0, 0, self.scView.frame.size.width, 44);
        
        CGRect rect = self.scView.frame;
        self.webView.frame = rect;
    }];
    naviFlag = YES;
}

#pragma mark - buttonControl
- (IBAction)closeClick:(UIButton *)sender {
    [self naviHide];
}

- (IBAction)homeClick:(UIButton *)sender {
    NSString* url = [self.webView.URL absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"home"];
    [self naviHide];
}
@end
