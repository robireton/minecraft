#!/usr/bin/perl

use strict;
use warnings;
my ($x0, $y0, $z0) = (466, 38, -765);

#Terraforming
#~ for my $y (-5..15) {
    #~ for my $x (-30..1) {
        #~ for my $z (0..16) {
            #~ setblock($x, $y, $z,  'sandstone');
            #~ setblock($x, $y, -$z-1, 'sandstone');
        #~ }
    #~ }
#~ }

for my $y (-2..10) {
    for my $x (-25..0) {
        for my $z (0..12) {
            setblock($x, $y, $z,  'air');
            setblock($x, $y, -$z-1, 'air');
        }
    }
}

sub setblock {
    my ($x, $y, $z, $material) = @_;
    printf("setblock %i %i %i %s\n", $x0+$x, $y0+$y, $z0+$z, $material);
}
