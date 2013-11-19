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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MDSlickMenu *menuObject;
@property (nonatomic, strong) NSArray *categories;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set ourselves as delegate
    [self.menuObject setDelegate:self];
    
    // Choosing an animation style
    self.menuObject.animationStyle = MDSMAnimationStyleLeftToRight;
    
    // Our data
    self.categories = @[@"All", @"Shows", @"Play & Learn", @"Classics", @"Favourites", @"Movies"];
    
    // Let's get some data up in here
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
