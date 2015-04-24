//
//  IXBaseControl.h
//  Ignite Engine
//
//  Created by Robert Walsh on 10/3/13.
//  Copyright (c) 2015 Apigee. All rights reserved.
//


#import "IXBaseObject.h"
#import "IXControlContentView.h"

@class IXSandbox;
@class IXControlLayoutInfo;

@interface IXBaseControl : IXBaseObject  <IXControlContentViewTouchDelegate>

@property (nonatomic,strong,readonly) IXControlContentView* contentView;
@property (nonatomic,strong,readonly) IXControlLayoutInfo* layoutInfo;
@property (nonatomic,assign,getter = shouldNotifyParentOfLayoutUpdates) BOOL notifyParentOfLayoutUpdates;
@property (nonatomic,strong) NSDictionary* subControlsDictionary;

-(void)buildView;
-(BOOL)isContentViewVisible;
-(void)conserveMemory;

-(void)layoutControl;
-(void)layoutControlContentsInRect:(CGRect)rect;
-(CGSize)preferredSizeForSuggestedSize:(CGSize)size;

-(void)processBeginTouch:(BOOL)fireTouchActions;
-(void)processCancelTouch:(BOOL)fireTouchActions;
-(void)processEndTouch:(BOOL)fireTouchActions;

-(IXBaseControl*)getTouchedControl:(UITouch*)touch;

@end
