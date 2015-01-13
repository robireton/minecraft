#!/usr/bin/perl

use warnings;
use strict;
use POSIX;

my ($x0, $y0, $z0) = (-20, 63, 0);
my ($floor_height, $floors) = (5, 8);
my $height = 1 + $floor_height * $floors;
my ($block, $stairs, $window, $light, $fence, $gate) = ('minecraft:sandstone', 'minecraft:sandstone_stairs', 'minecraft:glass_pane', 'minecraft:sea_lantern', 'minecraft:acacia_fence', 'minecraft:acacia_fence_gate');

#clear the area above
fill(-9,  1, -9,  9, $height+10,  9, 'minecraft:air');

#the base
fill(-6, -3, -9,  6, 0, 9, $block);
fill(-9, -3, -6,  9, 0, 6, $block);
fill(-8, -3, -8,  8, 0, 8, $block);
fill(-1,  1, -7,  1, 1, 7, $block);
fill(-7,  1, -1,  7, 1, 1, $block);

fill(-8, 1, -2, -8, 1,  2, $stairs, 0);
fill( 8, 1, -2,  8, 1,  2, $stairs, 1);
fill(-2, 1, -8,  2, 1, -8, $stairs, 2);
fill(-2, 1,  8,  2, 1,  8, $stairs, 3);

fill(-2, 1, -7, -2, 1,  7, $stairs, 0);
fill( 2, 1, -7,  2, 1,  7, $stairs, 1);
fill(-7, 1, -2,  7, 1, -2, $stairs, 2);
fill(-7, 1,  2,  7, 1,  2, $stairs, 3);

fill(-6, 1, -2, -6, 1,  2, $block);
fill( 6, 1, -2,  6, 1,  2, $block);
fill(-2, 1, -6,  2, 1, -6, $block);
fill(-2, 1,  6,  2, 1,  6, $block);

#basement
fill(-5, -2, -5,  5, 1, 5, $block);
fill(-3, -2, -3,  3, 1, 3, 'minecraft:air');

#core shaft
fill(-2, -2, -2, 2, $height, 2, $block);
fill(-1, -2, -1, 1, $height, 1, 'minecraft:air');
fill( 0, -2,  0,   0, $height + 2,  0, $block);
setblock(0, $height+3, 0, $light);

for my $x (-1, 1) {
    for my $z (-1, 1) {

        fill(2*$x, 2, 2*$z, 2*$x, $height, 2*$z, 'minecraft:air');
        setblock(   $x, -1, 3*$z, 'minecraft:torch', {'-1-1' => 4, '-11' => 3, '1-1' => 4, '11' => 3}->{"$x$z"});
        setblock( 3*$x, -1,   $z, 'minecraft:torch', {'-1-1' => 2, '-11' => 2, '1-1' => 1, '11' => 1}->{"$x$z"});

        #main support piers
        fill( 3*$x, -2,  4*$z,  4*$x, $height + 1,  5*$z, $block);
        fill( 4*$x, -2,  3*$z,  5*$x, $height + 1,  4*$z, $block);

        #main support pier capstones
        setblock(4*$x,  1+$height, 5*$z, $stairs, {'-1-1' => 0, '-11' => 0, '1-1' => 1, '11' => 1}->{"$x$z"});
        setblock(5*$x,  1+$height, 4*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});
        setblock(5*$x,  2+$height, 3*$z, $stairs, {'-1-1' => 0, '-11' => 0, '1-1' => 1, '11' => 1}->{"$x$z"});
        setblock(3*$x,  2+$height, 5*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});

        #buttresses
        fill(6*$x,  0, 3*$z, 6*$x,       $height       , 3*$z, $block);
        fill(3*$x,  0, 6*$z, 3*$x,       $height       , 6*$z, $block);
        fill(7*$x,  0, 3*$z, 7*$x, floor($height*0.618), 3*$z, $block);
        fill(3*$x,  0, 7*$z, 3*$x, floor($height*0.618), 7*$z, $block);
        fill(8*$x,  0, 3*$z, 8*$x, floor($height*0.382), 3*$z, $block);
        fill(3*$x,  0, 8*$z, 3*$x, floor($height*0.382), 8*$z, $block);

        #buttress capstones
        setblock(6*$x,  1+$height         , 3*$z, $stairs, {'-1-1' => 0, '-11' => 0, '1-1' => 1, '11' => 1}->{"$x$z"});
        setblock(3*$x,  1+$height         , 6*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});
        setblock(7*$x, ceil($height*0.618), 3*$z, $stairs, {'-1-1' => 0, '-11' => 0, '1-1' => 1, '11' => 1}->{"$x$z"});
        setblock(3*$x, ceil($height*0.618), 7*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});
        setblock(8*$x, ceil($height*0.382), 3*$z, $stairs, {'-1-1' => 0, '-11' => 0, '1-1' => 1, '11' => 1}->{"$x$z"});
        setblock(3*$x, ceil($height*0.382), 8*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});

        #plaza lighting
        setblock(5*$x, 1, 5*$z, $light);

        #plaza/tower junction
        setblock(3*$x, 1, 9*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});
        setblock(4*$x, 1, 8*$z, $stairs, {'-1-1' => 0, '-11' => 0, '1-1' => 1, '11' => 1}->{"$x$z"});
        setblock(4*$x, 1, 7*$z, $stairs, {'-1-1' => 0, '-11' => 0, '1-1' => 1, '11' => 1}->{"$x$z"});
        setblock(4*$x, 1, 6*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});
        setblock(5*$x, 1, 6*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});
        setblock(6*$x, 1, 6*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});
        setblock(6*$x, 1, 5*$z, $stairs, {'-1-1' => 0, '-11' => 0, '1-1' => 1, '11' => 1}->{"$x$z"});
        setblock(6*$x, 1, 4*$z, $stairs, {'-1-1' => 0, '-11' => 0, '1-1' => 1, '11' => 1}->{"$x$z"});
        setblock(7*$x, 1, 4*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});
        setblock(8*$x, 1, 4*$z, $stairs, {'-1-1' => 2, '-11' => 3, '1-1' => 2, '11' => 3}->{"$x$z"});
        setblock(9*$x, 1, 3*$z, $stairs, {'-1-1' => 0, '-11' => 0, '1-1' => 1, '11' => 1}->{"$x$z"});
    }
}

#decorative facade
fill(-5, 2, -3,  -5, $height - 1,  3, 'minecraft:red_sandstone');
fill(-3, 2,  5,   3, $height - 1,  5, 'minecraft:red_sandstone');
fill( 3, 2, -5,  -3, $height - 1, -5, 'minecraft:red_sandstone');
fill( 5, 2,  3,   5, $height - 1, -3, 'minecraft:red_sandstone');

fill(-5, $height, -2, -5, $height,  2, $stairs, 0);
fill( 5, $height, -2,  5, $height,  2, $stairs, 1);
fill(-2, $height, -5,  2, $height, -5, $stairs, 2);
fill(-2, $height,  5,  2, $height,  5, $stairs, 3);

#ground floor
fill(-3, 1, -3, -3, 1,  3, $stairs, 4);
fill( 3, 1, -3,  3, 1,  3, $stairs, 5);
fill(-3, 1, -3,  3, 1, -3, $stairs, 6);
fill(-3, 1,  3,  3, 1,  3, $stairs, 7);


for my $floor (1 .. $floors) {
    my $y = 1 + $floor * $floor_height;
    for my $i (-1, 1) {
        fill(  -1, $y-4, 5*$i,     1, $y-1, 5*$i, 'minecraft:red_sandstone', 2);
        fill(5*$i, $y-4,   -1,  5*$i, $y-1,    1, 'minecraft:red_sandstone', 2);
        fill(   0, $y-3, 5*$i,     0, $y-2, 5*$i, $window);
        fill(5*$i, $y-3,    0,  5*$i, $y-2,    0, $window);
    }

    fill(-3, $y, -1, -3, $y,  1, $stairs, 4);
    fill( 3, $y, -1,  3 ,$y,  1, $stairs, 5);
    fill(-1, $y, -3,  1, $y, -3, $stairs, 6);
    fill(-1, $y,  3,  1, $y,  3, $stairs, 7);

    fill(-1, $y, -4,  1, $y, -4, $stairs, 7);
    fill(-1, $y,  4,  1, $y,  4, $stairs, 6);
    fill(-4, $y, -1, -4, $y,  1, $stairs, 5);
    fill( 4, $y, -1,  4, $y,  1, $stairs, 4);


    for my $x (-1, 1) {
        for my $z (-1, 1) {
            setblock( 4*$x, $y, 2*$z, $stairs, {'-1-1' => 7, '-11' => 6, '1-1' => 7, '11' => 6}->{"$x$z"});
            setblock( 2*$x, $y, 4*$z, $stairs, {'-1-1' => 5, '-11' => 5, '1-1' => 4, '11' => 4}->{"$x$z"});
            setblock( 3*$x, $y, 2*$z, $stairs, {'-1-1' => 5, '-11' => 5, '1-1' => 4, '11' => 4}->{"$x$z"});
            setblock( 2*$x, $y, 3*$z, $stairs, {'-1-1' => 7, '-11' => 6, '1-1' => 7, '11' => 6}->{"$x$z"});
            setblock( 3*$x, $y, 3*$z, $stairs, {'-1-1' => 5, '-11' => 5, '1-1' => 4, '11' => 4}->{"$x$z"});

            setblock( 2*$x, $y, 2*$z, 'minecraft:stone_slab', 9);

            setblock(   $x, $y-3, 3*$z, 'minecraft:torch', {'-1-1' => 4, '-11' => 3, '1-1' => 4, '11' => 3}->{"$x$z"});
            setblock( 3*$x, $y-3,   $z, 'minecraft:torch', {'-1-1' => 2, '-11' => 2, '1-1' => 1, '11' => 1}->{"$x$z"});
        }
    }
}

fill(-2, 1+$height, -2, -2, 1+$height,  1, $fence);
fill(-2, 1+$height,  2,  1, 1+$height,  2, $fence);
fill( 2, 1+$height,  2,  2, 1+$height, -1, $fence);
fill( 2, 1+$height, -2, -1, 1+$height, -2, $fence);

setblock( 4, 1+$height,  0, $gate, 3);
setblock(-4, 1+$height,  0, $gate, 1);
setblock( 0, 1+$height,  4, $gate, 0);
setblock( 0, 1+$height, -4, $gate, 2);

for my $y (0..3) {
    fill(-4+$y, 4+$height+$y, -4+$y, -4+$y, 4+$height+$y,  4-$y, $stairs, 0);
    fill( 4-$y, 4+$height+$y, -4+$y,  4-$y, 4+$height+$y,  4-$y, $stairs, 1);
    fill(-3+$y, 4+$height+$y, -4+$y,  3-$y, 4+$height+$y, -4+$y, $stairs, 2);
    fill(-3+$y, 4+$height+$y,  4-$y,  3-$y, 4+$height+$y,  4-$y, $stairs, 3);
}

for my $y (0..2) {
    fill(-3+$y, 4+$height+$y, -3+$y, -3+$y, 4+$height+$y,  3-$y, $stairs, 5);
    fill( 3-$y, 4+$height+$y, -3+$y,  3-$y, 4+$height+$y,  3-$y, $stairs, 4);
    fill(-2+$y, 4+$height+$y, -3+$y,  2-$y, 4+$height+$y, -3+$y, $stairs, 7);
    fill(-2+$y, 4+$height+$y,  3-$y,  2-$y, 4+$height+$y,  3-$y, $stairs, 6);
}

for my $x (-1, 1) {
    for my $z (-1, 1) {
        fill(  $x, 1+$height, 4*$z, 2*$x, 1+$height, 4*$z, $fence);
        fill(4*$x, 1+$height,   $z, 4*$x, 1+$height, 2*$z, $fence);

        fill(4*$x, 2+$height, 3*$z, 4*$x, 3+$height, 3*$z, $block);
        fill(3*$x, 2+$height, 4*$z, 3*$x, 3+$height, 4*$z, $block);
        setblock( 4*$x, 3+$height, 2*$z, $stairs, {'-1-1' => 7, '-11' => 6, '1-1' => 7, '11' => 6}->{"$x$z"});
        setblock( 2*$x, 3+$height, 4*$z, $stairs, {'-1-1' => 5, '-11' => 5, '1-1' => 4, '11' => 4}->{"$x$z"});

        #spires
        fill(4*$x, 1+$height, 4*$z, 4*$x, 6+$height, 4*$z, 'minecraft:red_sandstone');
        setblock(4*$x, 7+$height, 4*$z, $light);
    }
}

setblock(0, 6+$height, 0, 'minecraft:stone_slab', 9);
setblock(0, 7+$height, 0, 'minecraft:netherrack');
setblock(0, 8+$height, 0, 'minecraft:fire');


sub fill {
    my ($x1, $y1, $z1, $x2, $y2, $z2, $material, $data) = @_;
    printf("fill %i %i %i %i %i %i %s %d\n", $x0+$x1, $y0+$y1, $z0+$z1, $x0+$x2, $y0+$y2, $z0+$z2, $material, $data || 0);
}

sub setblock {
    my ($x, $y, $z, $material, $data) = @_;
    printf("setblock %i %i %i %s %d\n", $x0+$x, $y0+$y, $z0+$z, $material, $data || 0);
}

