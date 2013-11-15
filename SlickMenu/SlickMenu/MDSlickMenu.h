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

// Item selected at index
- (void)slickMenu:(MDSlickMenu *)slickMenu didSelectItemAtIndex:(NSInteger)index;

// Specific height for a given index
- (NSInteger)slickMenu:(MDSlickMenu *)slickMenu heightForItemAtIndex:(NSInteger)index;

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
    MDSMAnimationStyleLeftToRight,
    MDSMAnimationStyleDrop,
    MDSMAnimationStyleAccordion
} MDSlickMenuAnimationStyle;

@property (nonatomic, assign) id <MDSlickMenuDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, assign) MDSlickMenuAnimationStyle animationStyle;

/* Will ask the delegate for data */
- (void)reloadData;

@end
