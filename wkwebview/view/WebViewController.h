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

@interface WebViewController : UIViewController <WKUIDelegate>

@property (weak, nonatomic) IBOutlet UIView *safeView;
@property (weak, nonatomic) IBOutlet UIScrollView *scView;

@end

NS_ASSUME_NONNULL_END
