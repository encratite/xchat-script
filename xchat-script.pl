use strict;
use warnings;
use Win32::API;
use Xchat ();

sub getFoobarTitle {
    my $FindWindow = Win32::API->new('user32', 'FindWindow', 'PP', 'N');
    my $GetWindowText = Win32::API->new('user32', 'GetWindowText', 'LPI', 'I');
    my $handle = $FindWindow->Call('{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}', 0);
    die 'The audio player is not running' if $handle == 0;
    my $buffer = ' ' x 256;
    my $stringLength = $GetWindowText->Call($handle, $buffer, length $buffer);
    my $title = substr($buffer, 0, $stringLength);
    if($title =~ /^(.+?)   \[foobar2000 .+?\]$/) {
        return $1;
    } else {
        die 'Unable to extract the title!'
    }
}

sub sayCurrentSong {
    eval {
        my $title = getFoobarTitle;
        Xchat::command("me $title");
    };
    if($@) {
        Xchat::command("echo $@");
    }
}

Xchat::register('Random stuff', '1', 'Random personal scripts');
Xchat::hook_command('audio', \&sayCurrentSong);
