//
//  CMBaseSearchDisplayViewController.m
//  TrCommerce
//
//  Created by Tristan on 15/11/6.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "CMBaseSearchDisplayViewController.h"

@implementation CMBaseSearchDisplayViewController

#pragma mark - life cycle

- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController
{
    self = [super initWithSearchBar:searchBar contentsController:viewController];
    if (self) {
        // Custom initialization
        _resultsSource = [NSMutableArray array];
        _editingStyle = UITableViewCellEditingStyleDelete;
        
        self.searchResultsDataSource = self;
        self.searchResultsDelegate = self;
        self.searchResultsTitle = NSLocalizedString(@"searchResults", @"The search results");
    }
    return self;
}

#pragma mark - UITableView method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.resultsSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellForRowAtIndexPathCompletion) {
        return _cellForRowAtIndexPathCompletion(tableView, indexPath);
    }
    else{
        //implemention in sub class
        return nil;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (_canEditRowAtIndexPath) {
        return _canEditRowAtIndexPath(tableView, indexPath);
    }
    else{
        return NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_heightForRowAtIndexPathCompletion) {
        return _heightForRowAtIndexPathCompletion(tableView, indexPath);
    }
    
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editingStyle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didSelectRowAtIndexPathCompletion) {
        return _didSelectRowAtIndexPathCompletion(tableView, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didDeselectRowAtIndexPathCompletion) {
        _didDeselectRowAtIndexPathCompletion(tableView, indexPath);
    }
}


@end
