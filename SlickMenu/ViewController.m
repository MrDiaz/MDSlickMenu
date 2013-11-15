//
//  ViewController.m
//  SlickMenu
//
//  Created by Manuel Diaz on 2013-10-17.
//  Copyright (c) 2013 Manuel Diaz. All rights reserved.
//

#import "ViewController.h"
#import "MDSlickMenu.h"
#import "MDSlickMenuItemView.h"

// Content properties
#define kStartingXPos   -500
#define kFinalXPos      18
#define kStartingYPos   50

// Item sizes
#define kItemWidth 300
#define kItemHeight 40

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MDSlickMenu *menuObject;
@property (nonatomic, strong) NSArray *categories;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.menuObject setDelegate:self];
    
    self.categories = @[@"All Categories", @"Abstract", @"Animals", @"Black and White", @"Celebrities", @"City and Architecture", @"Commercial", @"Concert", @"Family", @"Fashion", @"Film", @"Art", @"Food", @"Landscapes", @"Macro", @"Nature", @"People", @"Performing Art", @"Transportation", @"Travel", @"Underwater", @"Street", @"Still Life", @"Wedding", @"Urban Exploration", @"Gaming", @"Movies", @"Shows"];
    
    [self.menuObject reloadData];
}

#pragma mark - 
#pragma mark - MDSlickMenu Delegate

-(NSInteger)numberOfItemsInMenu:(MDSlickMenu *)slickMenu {
    return self.categories.count;
}

-(NSString*)itemNameAtIndex:(NSInteger)index {
    return self.categories[index];
}

- (void)slickMenu:(MDSlickMenu *)slickMenu didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"Selected %@", self.categories[index]);
}

@end
