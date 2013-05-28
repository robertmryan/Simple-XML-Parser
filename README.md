# Simple XML Parser

--

## Introduction

This is a very simple `NSXMLParser` based parser, which shows how to parse a XML feed that represents an array of items into an `NSArray` of `NSDictionary` items.

For example, you might have have some code that says:

    NSURL *url = [NSURL URLWithString:@"http://rss.news.yahoo.com/rss"];
    Parser *parser = [[Parser alloc] initWithContentsOfURL:url];
    parser.rowElementName = @"item";
    parser.elementNames = @[@"title", @"description", @"link", @"pubDate"];
    [parser parse];

The array of dictionary items is now in a `NSArray`, `parser.items`. You can extract data from it such as follows:
 
    NSDictionary *firstItem = parser.items[0];
    NSString *title = firstItem[@"title"];
    
For a more complete demonstration, refer to the code in this project which entails parsing the RSS feed for Yahoo! Top News.

For something more complicated, where you want to parse the entire XML into a structure that captures all of the tags and full nesting of the elements, see my [XMLNodeParser](https://github.com/robertmryan/xml-node-parser). But this simple XML parser is adequate for many simple projects.

--

If you have any questions, do not hesitate to post an issue here on github

Rob Ryan

28 May 2013

