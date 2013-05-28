//
//  Parser.h
//  Simple Parser
//
//  Created by Robert Ryan on 5/28/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

/** @class      Parser
 
    @abstract   A `NSXMLParserDelegate` object for parsing XML feeds that are represented by a simple array of
                items, such as a RSS feed.
 
    @example   For example, you might have have some code that says:

    NSURL *url = [NSURL URLWithString:@"http://rss.news.yahoo.com/rss"];
    Parser *parser = [[Parser alloc] initWithContentsOfURL:url];
    parser.rowElementName = @"item";
    parser.elementNames = @[@"title", @"description", @"link", @"pubDate"];
    [parser parse];

The array of dictionary items is now in `parser.items`. For example
 
    NSDictionary *firstItem = parser.items[0];
    NSString *title = firstItem[@"title"];

 */

@interface Parser : NSXMLParser

/** @property   rowElementName
 
    @abstract   The element name that identifies a new row of data in the XML.
 */
 
@property (nonatomic, copy) NSString *rowElementName;

/** @property   attributeNames
 
    @abstract   The array of attributes we might want to retrieve for that row element name.
 */

@property (nonatomic, copy) NSArray *attributeNames;

/** @property   elementNames
 
    @abstract   The list of sub element names for which we're retrieving values.
 */

@property (nonatomic, copy) NSArray *elementNames;

/** @property   items
 
    @abstract   After parsing, this is the array of parsed items.
 */

@property (nonatomic, strong) NSMutableArray *items;

@end
