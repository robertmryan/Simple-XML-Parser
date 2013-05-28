//
//  WebViewController.m
//  Simple XML Parser
//
//  Created by Robert Ryan on 5/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:self.newsTitle];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

@end
