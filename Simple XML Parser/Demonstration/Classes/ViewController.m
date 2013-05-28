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
#import "Cell.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) NSCache *imageCache;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageCache = [[NSCache alloc] init];
    
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

- (NSArray *)imagesFromString:(NSString *)string
{
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];

    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, [string length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {

                             NSString *imgUrlString = [string substringWithRange:[result rangeAtIndex:2]];
                             [imageUrls addObject:[NSURL URLWithString:imgUrlString]];
                         }];

    return imageUrls;
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
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *object = _objects[indexPath.row];
    cell.cellTitle.text = object[@"title"];
    cell.cellSubtitle.text = object[@"pubDate"];

    cell.cellImageView.image = nil;
    [self tableView:tableView updateImageForCell:cell indexPath:indexPath];
    return cell;
}

// It's probably better to use a `UIImageView` category, such as provided by `SDWebImage` or
// `AFNetworking`, which does all of this, but I was reluctant to add third party libraries
// to this project which is focusing on XML Parsing.

- (void)tableView:(UITableView *)tableView updateImageForCell:(Cell *)cell indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *object = _objects[indexPath.row];

    NSArray *imageUrls = [self imagesFromString:object[@"description"]];

    if ([imageUrls count] > 0)
    {
        NSURL *url = imageUrls[0];
        UIImage *image = [self.imageCache objectForKey:[url absoluteString]];
        if (image)
        {
            cell.cellImageView.image = image;
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:imageUrls[0]];
                UIImage *image = [UIImage imageWithData:data];
                if (!image) return;

                [self.imageCache setObject:image forKey:[url absoluteString]];

                dispatch_async(dispatch_get_main_queue(), ^{
                    Cell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                    {
                        updateCell.cellImageView.image = image;
                    }
                });
            });
        }
    }
}
@end
