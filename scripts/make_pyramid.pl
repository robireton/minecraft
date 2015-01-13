#!/usr/bin/perl

use strict;
use warnings;
my ($x0, $y0, $z0) = (568, 4, -1400);
my $size = 62;

for my $y (-5 .. -1) {
    for my $x (-$size + 1 .. $size) {
        for my $z (-$size + 1 .. $size) {
            setblock( $x, $y, $z, 'sandstone');
        }
    }
}

my $temenos = $size + 3;
for my $y (-4 .. 2) {
    for my $i ( -$temenos .. $temenos ) {
        setblock( -$temenos,   $y,  $i,         'sandstone', $y==2 ? 2 : 0);
        setblock(  $temenos+1, $y,  $i+1,       'sandstone', $y==2 ? 2 : 0);
        setblock(  $i+1,       $y, -$temenos,   'sandstone', $y==2 ? 2 : 0);
        setblock(  $i,         $y,  $temenos+1, 'sandstone', $y==2 ? 2 : 0);
    }
}

for my $y (0 .. 2) {
    for my $j ($size .. $temenos-1) {
        for my $i ( -$j .. $j ) {
            setblock( -$j,   $y,  $i,   'air');
            setblock(  $j+1, $y,  $i+1, 'air');
            setblock(  $i+1, $y, -$j,   'air');
            setblock(  $i,   $y,  $j+1, 'air');
        }
    }
}

for my $y (0..($size-1)) {
    my $level = $size - $y - 1;

    if ($level > 0) {
        for my $x ((-$level+1) .. $level) {
            for my $z ((-$level+1) .. $level) {
                setblock( $x, $y,  $z, 'sandstone');
            }
        }
    }

    for my $i (-$level..$level) {
        setblock( -$level,   $y,  $i,       $level ? 'sandstone_stairs' : 'quartz_stairs', 0);
        setblock(  $level+1, $y,  $i+1,     $level ? 'sandstone_stairs' : 'quartz_stairs', 1);
        setblock(  $i+1,     $y, -$level,   $level ? 'sandstone_stairs' : 'quartz_stairs', 2);
        setblock(  $i,       $y,  $level+1, $level ? 'sandstone_stairs' : 'quartz_stairs', 3);
    }
}

sub setblock {
    my ($x, $y, $z, $material, $data) = @_;
    printf("setblock %i %i %i %s %d replace\n", $x0+$x, $y0+$y, $z0+$z, $material, $data || 0);
}


=cut
setblock 0 4 0 sandstone_stairs 0 replace
setblock 2 4 0 sandstone_stairs 1 replace
setblock 4 4 0 sandstone_stairs 2 replace
setblock 6 4 0 sandstone_stairs 3 replace

tp rob_ireton 406 67 -835
tp rob_ireton 406 66 -715
tp rob_ireton 526 67 -835
tp rob_ireton 526 65 -715

setblock 477 50 -769 mob_spawner 0 replace {EntityId:Zombie}
