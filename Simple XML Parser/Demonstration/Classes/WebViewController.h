//
//  WebViewController.h
//  Simple XML Parser
//
//  Created by Robert Ryan on 5/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, strong) NSString *newsTitle;
@property (nonatomic, strong) NSURL *url;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
