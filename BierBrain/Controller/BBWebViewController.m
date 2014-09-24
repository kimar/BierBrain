//
//  BBWebViewController.m
//  BierBrain
//
//  Created by Marcus Kida on 28.10.12.
//  Copyright (c) 2012 Marcus Kida. All rights reserved.
//

#import "BBWebViewController.h"

@interface BBWebViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView *m_pWebView;
    
    NSString *m_stTitle;
    NSURL *m_pUrl;
}
@end

@implementation BBWebViewController

@synthesize m_stTitle;
@synthesize m_pUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set title
    [self setTitle:m_stTitle?m_stTitle:NSLocalizedString(@"licenses", nil)];
    
    // If url is null we will display ourt licenses file, this way we can evoid to implement an information viewcontroller
    if(m_pUrl)
        [m_pWebView loadRequest:[NSURLRequest requestWithURL:m_pUrl]];
    else
        [m_pWebView loadData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Licenses"
                                                                                            ofType:@"html"]]
                    MIMEType:@"text/html"
            textEncodingName:@"utf-8"
                     baseURL:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self dismissStatusbarOverlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showStatusbarOverlay];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dismissStatusbarOverlay];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self dismissStatusbarOverlay];
}

#pragma mark - Statusbar Overlay
- (void) showStatusbarOverlay
{
    // Show aniamted statusbar overlay
    BWStatusBarOverlay *pStatusBarOverlay = [BWStatusBarOverlay shared];
    [pStatusBarOverlay setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [pStatusBarOverlay showWithMessage:@"Suche nach Bieren..." loading:YES animated:YES];
}

- (void) dismissStatusbarOverlay
{
    // Dismiss statusbar overlay
    BWStatusBarOverlay *pStatusBarOverlay = [BWStatusBarOverlay shared];
    [pStatusBarOverlay dismissAnimated:YES];
}

@end
