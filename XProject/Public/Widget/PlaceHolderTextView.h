//
//  PlaceHolderTextView.h
//  带PlaceHolder的TextView
//
//  Created by Jerry.Yao
//
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholderText;
@property (nonatomic, retain) UIColor  *placeholderColor;

#pragma mark - text改变监听
-(void)textChanged:(NSNotification*)notification;

@end
