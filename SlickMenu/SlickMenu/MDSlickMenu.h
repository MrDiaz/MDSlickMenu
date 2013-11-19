//
//  MDSlickMenu.h
//  SlickMenu
//
//  Created by Manuel Diaz on 2013-10-17.
//  Copyright (c) 2013 Manuel Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDSlickMenu;

/*
 *  Protocol definition
 */

@protocol MDSlickMenuDelegate <NSObject>

@optional

// Called after the user makes a selection. Will hide the menu
- (void)slickMenu:(MDSlickMenu *)slickMenu didSelectItemAtIndex:(NSInteger)index;

@required

// Title for an item at specific index
- (NSString *)itemNameAtIndex:(NSInteger)index;

// How many items?
- (NSInteger)numberOfItemsInMenu:(MDSlickMenu *)slickMenu;

@end

/*
 *  Slick menu interface
 */
@interface MDSlickMenu : UIControl

typedef enum  {
    MDSMAnimationStyleLeftToRight = 0,
    MDSMAnimationStyleDrop,
    MDSMAnimationStyleAccordion
} MDSlickMenuAnimationStyle;

@property (nonatomic, assign) id <MDSlickMenuDelegate> delegate;

/* Duration of animation in seconds */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/* Type of animation to use */
@property (nonatomic, assign) MDSlickMenuAnimationStyle animationStyle;

/* Will ask the delegate for data */
- (void)reloadData;

@end
