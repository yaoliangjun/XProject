//
//  PlaceHolderTextView.m
//
//  Created by Jerry.Yao
//
//

#import "PlaceHolderTextView.h"

CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

@interface PlaceHolderTextView ()

@property (nonatomic, retain) UILabel *placeHolderLabel;

@end


#pragma mark - 带PlaceHolder的TextView
@implementation PlaceHolderTextView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (!self.placeholderText) {
        [self setPlaceholderText:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setPlaceholderText:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholderText] length] == 0) {
        return;
    }
    
    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        PlaceHolderTextView *textView = [self viewWithTag:999];
        if([[self text] length] == 0) {
            
            [textView setAlpha:1];
//            [[self viewWithTag:999] setAlpha:1];
        }
        else {
            textView.alpha = 0;
//            [[self viewWithTag:999] setAlpha:0];
        }
    }];
}

//- (void)setText:(NSString *)text
//{
//    [super setText:text];
//    [self textChanged:nil];
//}

- (void)drawRect:(CGRect)rect
{
    if([[self placeholderText] length] > 0) {
        if (_placeHolderLabel == nil) {
            // Chanage 8 -> 0 for left alignment
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10,self.bounds.size.width,10)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
            
            self.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        }
        
        _placeHolderLabel.text = self.placeholderText;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if([[self text] length] == 0 && [[self placeholderText] length] > 0) {
//        [[self viewWithTag:999] setAlpha:1];
        PlaceHolderTextView *textView = [self viewWithTag:999];
        textView.alpha = 1;
    }
    
    [super drawRect:rect];
}

@end
