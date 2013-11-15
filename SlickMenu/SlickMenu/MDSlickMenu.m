//
//  MDSlickMenu.m
//  SlickMenu
//
//  Created by Manuel Diaz on 2013-10-17.
//  Copyright (c) 2013 Manuel Diaz. All rights reserved.
//

#import "MDSlickMenu.h"
#import "MDSlickMenuItemView.h"

// Content properties
#define kStartingXPos   -500
#define kFinalXPos      0
#define kStartingYPos   50

@interface MDSlickMenu ()

@property (nonatomic, strong) NSArray *items; // The items in the menu
@property (nonatomic, strong) UIView *backgroundView; // Background view for the whole menu when opened
@property (nonatomic, strong) UIScrollView *scrollView; // Used to add our menu items
@property (nonatomic, strong) UIButton *button; // Initiates the action
@property (nonatomic, strong) UITapGestureRecognizer *tap; // To detect user taps
@property (nonatomic, assign) BOOL isOpened; // Indicates wether menu is opened or close

@end

@implementation MDSlickMenu

#pragma mark -
#pragma mark - Datasource Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    
	if (self) {
        // Setup look & feel
        [self setupUI];
        
        // Add the tap recognizer
		_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapItem:)];
		[self.scrollView addGestureRecognizer:_tap];
        
        _animationDuration = 0.4;
	}
	return self;
}

#pragma mark - 
#pragma mark - UI Setup

-(void)setupUI {
    // Load the drop down action button
    _button = [[[NSBundle mainBundle] loadNibNamed:@"MDSlickMenuButton" owner:self options:nil] objectAtIndex:0];
    [_button addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the scrollview for the content
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _button.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_button];
}

#pragma mark -
#pragma mark - Data

/*
 * Find a label and return its index
 */
-(NSInteger)indexForView:(MDSlickMenuItemView*)itemView {
    NSInteger index = 0;
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[MDSlickMenuItemView class]]) {
            index++;
            if ([view isEqual:itemView]) {
                break;
            }
        }
    }
    return index - 1;
}

- (void)reloadData {
	[self buildItems];
}

- (void)buildItems {
	NSInteger numberOfItems = 0;
    MDSlickMenuItemView *view;
	if ([self.delegate respondsToSelector:@selector(numberOfItemsInMenu:)]) {
		numberOfItems = [self.delegate numberOfItemsInMenu:self];
		for (int i = 0; i < numberOfItems; i++) {
			view = [[[NSBundle mainBundle] loadNibNamed:@"MDSlickMenuItemView" owner:self options:nil] objectAtIndex:0];
			view.textLabel.text = [self itemNameAtIndex:i];
			[self.scrollView addSubview:view];
		}
	}
    
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width, numberOfItems * view.frame.size.height + view.frame.size.height)];
}

- (NSString *)itemNameAtIndex:(NSInteger)index {
	if ([self.delegate respondsToSelector:@selector(itemNameAtIndex:)]) {
		return [self.delegate itemNameAtIndex:index];
	}
    return nil;
}

- (void)setDelegate:(id <MDSlickMenuDelegate> )delegate {
	_delegate = delegate;
}

#pragma mark -
#pragma mark - Animations

- (void)open {
	_isOpened = YES;
    
    [self addSubview:_scrollView];
    
	[self animate];
}

- (void)close {
	_isOpened = NO;
    
    [self animate];
}

// Perform animation based on animation style chosen
-(void)animate {
    switch (self.animationStyle) {
        case MDSMAnimationStyleLeftToRight:
            [self animateLeftToRight];
            break;
        case MDSMAnimationStyleAccordion:
            break;
        case MDSMAnimationStyleDrop:
            break;
        default:
            [self animateLeftToRight];
            break;
    }
}

/* 500px look-alike animation */
-(void)animateLeftToRight {
    __block CGFloat yPos = 0;
    NSTimeInterval timeDelay = 0;
    
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        if ([[self.scrollView.subviews objectAtIndex:i] isKindOfClass:[MDSlickMenuItemView class]]) {
            MDSlickMenuItemView *itemView = [self.scrollView.subviews objectAtIndex:i];
            if (_isOpened) {
                itemView.frame = CGRectMake(kStartingXPos, yPos, itemView.frame.size.width, itemView.frame.size.height);
                itemView.alpha = 1.0f;
            }
            timeDelay = timeDelay + 0.02;
            
            [UIView animateWithDuration:0.2 delay:timeDelay options:UIViewAnimationOptionCurveEaseInOut animations: ^{
                if (_isOpened) {
                    itemView.frame = CGRectMake(kFinalXPos, yPos, itemView.frame.size.width, itemView.frame.size.height);
                    yPos += itemView.frame.size.height;
                }
                else {
                    itemView.frame = CGRectMake(kStartingXPos, itemView.frame.origin.y, itemView.frame.size.width, itemView.frame.size.height);
                }
            } completion: ^(BOOL finished) {
                if (_isOpened == NO) {
                    [_scrollView removeFromSuperview];
                }
            }];
        }
    }
}

-(void)animateDrop {
    __block CGFloat yPos = 0;
    NSTimeInterval timeDelay = 0;
	for (int i = 0; i < self.scrollView.subviews.count; i++) {
		if ([[self.scrollView.subviews objectAtIndex:i] isKindOfClass:[MDSlickMenuItemView class]]) {
			MDSlickMenuItemView *itemView = [self.scrollView.subviews objectAtIndex:i];
			itemView.frame = CGRectMake(kStartingXPos, yPos, itemView.frame.size.width, itemView.frame.size.height);
			timeDelay = timeDelay + 0.01;
			itemView.alpha = 1.0f;
			[UIView animateWithDuration:0.2 delay:timeDelay options:UIViewAnimationOptionCurveEaseInOut animations: ^{
			    itemView.frame = CGRectMake(kFinalXPos, yPos, itemView.frame.size.width, itemView.frame.size.height);
                yPos += itemView.frame.size.height;
			} completion: ^(BOOL finished) {
			}];
		}
	}
}

- (void)removeAllViewsExcept:(MDSlickMenuItemView *)itemView {
	_isOpened = NO;
	NSTimeInterval timeDelay = 0;
	for (int i = 0; i < self.scrollView.subviews.count; i++) {
		if ([[self.scrollView.subviews objectAtIndex:i] isKindOfClass:[MDSlickMenuItemView class]]) {
			MDSlickMenuItemView *view = [self.scrollView.subviews objectAtIndex:i];
			timeDelay = timeDelay + 0.03;
			if ([view isEqual:itemView] == NO) {
				[UIView animateWithDuration:_animationDuration delay:timeDelay options:UIViewAnimationOptionCurveEaseInOut animations: ^{
				    view.frame = CGRectMake(kStartingXPos, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
				} completion: ^(BOOL finished) {
				}];
			}
		}
	}
}

#pragma mark -
#pragma mark - User Interactions

- (void)didTapItem:(UITapGestureRecognizer *)recognizer {
    CGPoint pt = [recognizer locationInView:self];
	UIView *view = [self hitTest:pt withEvent:nil];
	
    if ([view isKindOfClass:[MDSlickMenuItemView class]]) { // Did we hit one of our views?
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
            _button.titleLabel.alpha = 0.0f;
        } completion: ^(BOOL finished) {
            [_button setTitle:@"" forState:UIControlStateNormal];
        }];
        
		MDSlickMenuItemView *itemView = (MDSlickMenuItemView*)view;
		[self removeAllViewsExcept:itemView];
        
		[UIView animateWithDuration:_animationDuration delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations: ^{
		    itemView.frame = CGRectMake(kFinalXPos, 0, itemView.frame.size.width, itemView.frame.size.height);
		} completion: ^(BOOL finished) {
            [self.button setTitle:itemView.textLabel.text forState:UIControlStateNormal];
            _button.titleLabel.alpha = 1.0f;
		    itemView.alpha = 0.0f;
            if ([self.delegate respondsToSelector:@selector(slickMenu:didSelectItemAtIndex:)]) {
		        [self.delegate slickMenu:self didSelectItemAtIndex:[self indexForView:itemView]];
			}
		}];
        
		return;
	}
}

- (void)toggleMenu:(id)sender {
	if (_isOpened) {
		[self close];
	}
	else {
		[self open];
	}
}

@end
