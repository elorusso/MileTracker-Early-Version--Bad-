//
//  ReportsViewController.m
//  MileTracker
//
//  Created by Emanuel on 12/24/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "ReportsViewController.h"
#import "PreviewViewController.h"

@interface ReportsViewController () {
    CGSize pfdSize;
    NSNumberFormatter *moneyFormat;
    NSMutableArray *allInfo;
}
@end

@implementation ReportsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Reports", @"Reports");
        
        moneyFormat = [[NSNumberFormatter alloc]init];
        moneyFormat.maximumFractionDigits = 2;
        moneyFormat.minimumFractionDigits = 2;
        moneyFormat.minimumIntegerDigits = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    NSArray *headers = [[NSArray alloc] initWithObjects:@"Date", @"Purpose", @"Type", @"Origin", @"Destination", @"Vehicle", @"Miles", @"Miles Deduction", @"Expenses", @"Total Deduction", @"Notes", nil];
    allInfo = [[NSMutableArray alloc]initWithObjects:headers, nil];
    allInfo = [self collectDataInArray:allInfo];
    [self generatePFD];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark-PDF methods

-(void)generatePFD {
    pfdSize = CGSizeMake(1100, 850);
    NSString *fileName = @"report.pdf";
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *fullPdfPath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    int pages = [allInfo count] / 13 + 1;
    
    UIGraphicsBeginPDFContextToFile(fullPdfPath, CGRectZero, nil);
    
    
    for (int i = 1; i <= pages; i++) {
        if (i == pages) {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pfdSize.width, pfdSize.height), nil);
            [self drawText:@"MileTracker Trip Report" inFrame:CGRectMake(30, 30, 900, 30) withFontName:@"Helvetica-Bold" andFontSize:22];
            [self drawText:[@"Page " stringByAppendingFormat:@"%i", i] inFrame:CGRectMake(1000, 30, 80, 80) withFontName:@"Helvetica" andFontSize:13];
            [self drawTableAt:CGPointMake(50, 80) withRowHeight:55 andColumnWidth:90 andRowCount:[allInfo count]%13 andColumnCount:11 inPage:i];
        }
        else {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pfdSize.width, pfdSize.height), nil);
            [self drawText:@"MileTracker Trip Report" inFrame:CGRectMake(30, 30, 900, 30) withFontName:@"Helvetica-Bold" andFontSize:22];
            [self drawText:[@"Page " stringByAppendingFormat:@"%i", i] inFrame:CGRectMake(1000, 30, 80, 80) withFontName:@"Helvetica" andFontSize:13];
            [self drawTableAt:CGPointMake(50, 80) withRowHeight:55 andColumnWidth:90 andRowCount:13 andColumnCount:11 inPage:i];
        }
    }
    
    
    UIGraphicsEndPDFContext();
}

-(void)drawTableAt:(CGPoint)origin
     withRowHeight:(int)rowHeight
    andColumnWidth:(int)columnWidth
       andRowCount:(int)numberOfRows
    andColumnCount:(int)numberOfColumns
            inPage:(int)page  {
    
    int padding = 2;
    int tripToStartPage = 13 * (page - 1);
    
    for (int i = 0; i <= numberOfRows; i++)
    {
        int newOrigin = origin.y + (rowHeight*i);
        
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x + (numberOfColumns*columnWidth), newOrigin);
        
        [self drawLineFromPoint:from to:to];
    }
    
    for (int i = 0; i <= numberOfColumns; i++)
    {
        int newOrigin = origin.x + (columnWidth*i);
        
        CGPoint from = CGPointMake(newOrigin, origin.y);
        CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
                
        [self drawLineFromPoint:from to:to];
    }
    
    for (int i = tripToStartPage; i < tripToStartPage + numberOfRows; i++) {
        NSArray *currentInfo = [allInfo objectAtIndex:i];
        
        for (int j = 0; j < numberOfColumns; j++) {
            
            int newOriginX = origin.x + (j*columnWidth);
            int newOriginY = origin.y + ((i - tripToStartPage)*rowHeight);
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
            if (i == 0) {
                [self drawText:[currentInfo objectAtIndex:j] inFrame:frame withFontName:@"Helvetica-Bold" andFontSize:13];
            }
            else if (j == 3||j == 4) [self drawText:[currentInfo objectAtIndex:j] inFrame:frame withFontName:@"Helvetica" andFontSize:10];
            else [self drawText:[currentInfo objectAtIndex:j] inFrame:frame withFontName:@"Helvetica" andFontSize:13];
        
        }
    }
}

-(void)drawLineFromPoint:(CGPoint) from to:(CGPoint)to {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
}

-(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect withFontName:(NSString *) fontName andFontSize:(int)size {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    [textToDraw drawInRect:frameRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}

-(NSMutableArray *)collectDataInArray:(NSMutableArray *)array {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"Data.plist"];
    NSArray *newarray = [[NSArray alloc] initWithContentsOfFile:documentDirectory];
    newarray = [newarray objectAtIndex:0];
    for (NSArray *catagory in newarray) {
        for (NSDictionary *trip in catagory) {
            if ([trip objectForKey:@"trip type"]) {
                double totalSavings = 0.0;
                if (![[trip objectForKey:@"trip type"] isEqualToString:@"Personal"] && ![[trip objectForKey:@"trip type"] isEqualToString:@"Other"] && [trip objectForKey:@"trip type"]) {
                    totalSavings = [[[trip objectForKey:@"trip expenses"] substringFromIndex:1] doubleValue] + [[trip objectForKey:@"trip savings"]doubleValue];
                }
                NSArray *row = [[NSArray alloc]initWithObjects:[trip objectForKey:@"trip start date"],
                                [trip objectForKey:@"trip name"],
                                [trip objectForKey:@"trip type"],
                                [trip objectForKey:@"trip origin"],
                                [trip objectForKey:@"trip destination"],
                                [trip objectForKey:@"trip vehicle"],
                                [trip objectForKey:@"trip miles"],
                                [trip objectForKey:@"trip savings"],
                                [trip objectForKey:@"trip expenses"],
                                [@"$" stringByAppendingString:[moneyFormat stringFromNumber:[NSNumber numberWithDouble:totalSavings]]],
                                [trip objectForKey:@"trip notes"], nil];
                [array addObject:row];
            }
        }
    }
    return array;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)showPreview:(UIBarButtonItem *)sender {
    PreviewViewController *preview = [[PreviewViewController alloc]init];
    [self presentViewController:preview animated:YES completion:nil];
}

- (IBAction)sendReport:(UIBarButtonItem *)sender {
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc]init];
    [mail setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]){
        [mail setSubject:@"MileTracker Trip Report"];
        [mail setMessageBody:@"This is a report sent from MileTracker. Please do not respond." isHTML:NO];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"report.pdf"];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        [mail addAttachmentData:data mimeType:@"application/pdf" fileName:@"report.pdf"];
        [self presentViewController:mail animated:YES completion:nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
