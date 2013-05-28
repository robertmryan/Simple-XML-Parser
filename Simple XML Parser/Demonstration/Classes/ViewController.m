//
//  ViewController.m
//  Simple XML Parser
//
//  Created by Robert Ryan on 5/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "ViewController.h"
#import "Parser.h"
#import "WebViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *objects;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self parse];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)parse
{
    NSURL *url = [NSURL URLWithString:@"http://rss.news.yahoo.com/rss"];
    Parser *parser = [[Parser alloc] initWithContentsOfURL:url];
    parser.rowElementName = @"item";
    parser.elementNames = @[@"title", @"description", @"link", @"pubDate"];
    [parser parse];
    
    self.objects = parser.items;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushToWebView"])
    {
        WebViewController *controller = segue.destinationViewController;
        
        NSDictionary *object = _objects[[self.tableView indexPathForSelectedRow].row];
        NSURL *url = [NSURL URLWithString:object[@"link"]];
        controller.url = url;
        controller.newsTitle = object[@"title"];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *object = _objects[indexPath.row];
    cell.textLabel.text = object[@"title"];
    cell.detailTextLabel.text = object[@"pubDate"];
    
    return cell;
}

@end
