#!/usr/bin/perl

use strict;
use warnings;
my ($x0, $y0, $z0) = (-304, 75, 138);

#Terraforming
for my $y (0..35) {
    for my $x (9..98) {
        for my $z (9..120) {
            setblock($x, $y, $z, 'air');
        }
    }
    for my $x (42..65) {
        for my $z (121..140) {
            setblock($x, $y, $z, 'air');
        }
    }
}
for my $y (-3..-1) {
    for my $x (9..98) {
        for my $z (9..99) {
            setblock($x, $y, $z, 'grass');
        }
    }
    for my $x (11..96) {setblock($x, $y, 100, 'grass');}
    for my $x (16..91) {setblock($x, $y, 101, 'grass');}
    for my $x (21..86) {setblock($x, $y, 102, 'grass');}
    for my $x (26..81) {setblock($x, $y, 103, 'grass');}
    for my $x (32..75) {setblock($x, $y, 104, 'grass');}
    for my $x (37..70) {setblock($x, $y, 105, 'grass');}
    for my $x (42..65) {setblock($x, $y, 106, 'grass');}
    for my $x (47..60) {setblock($x, $y, 107, 'grass');}
    for my $x (50..57) {setblock($x, $y, 108, 'grass');}
    for my $x (50..57) {setblock($x, $y, 109, 'grass');}
    for my $x (50..57) {setblock($x, $y, 110, 'grass');}
}

#Outer Curtain
for my $y (-14..5) {
    for my $z (6..8) {
        for my $x (6..101) {
            setblock($x, $y, $z, 'cobblestone');
        }
    }
    for my $x (6..8, 99..101) {
        for my $z (6..101) {
            setblock($x, $y, $z, 'cobblestone');
        }
    }
    for my $x ( 9..10, 97..98) {setblock($x, $y, 100, 'cobblestone');}
    for my $x ( 9..15, 92..98) {setblock($x, $y, 101, 'cobblestone');}
    for my $x ( 8..20, 87..99) {setblock($x, $y, 102, 'cobblestone');}
    for my $x (11..25, 82..96) {setblock($x, $y, 103, 'cobblestone');}
    for my $x (16..31, 76..91) {setblock($x, $y, 104, 'cobblestone');}
    for my $x (21..36, 71..86) {setblock($x, $y, 105, 'cobblestone');}
    for my $x (26..41, 66..81) {setblock($x, $y, 106, 'cobblestone');}
    for my $x (32..44, 64..75) {setblock($x, $y, 107, 'cobblestone');}
    for my $x (37..44, 64..70) {setblock($x, $y, 108, 'cobblestone');}
    for my $x (42..44, 64..65) {setblock($x, $y, 109, 'cobblestone');}
}

outer_tower(2,98);
outer_tower(0,50);
outer_tower(2,2);
outer_tower(50,0);
outer_tower(97,2);
outer_tower(99,50);
outer_tower(97,98);

outer_gatehouse(44, 107);
outer_gatehouse(55, 107);

#Inner Curtain
for my $y (-3..10) {
    for my $x (22..85) {
        for my $z (22..25, 82..85) {
            setblock($x, $y, $z, 'cobblestone');
        }
    }
    for my $x (22..25, 82..85) {
        for my $z (26..81) {
            setblock($x, $y, $z, 'cobblestone');
        }
    }
}
for my $y (-1..10) {
    for my $x (53..54) {
        for my $z (82..85) {
            setblock($x, $y, $z, 'air');
        }
    }
}

inner_tower(15,15);
inner_tower(78,15);
inner_tower(15,78);
inner_tower(78,78);

inner_gatehouse(38,76);
inner_gatehouse(55,76);

spiral_stairs(25,25);
spiral_stairs(78,25);
spiral_stairs(25,78);
spiral_stairs(37,75);
spiral_stairs(66,75);
spiral_stairs(78,78);

sub setblock {
    my ($x, $y, $z, $material) = @_;
    printf("setblock %i %i %i %s\n", $x0+$x, $y0+$y, $z0+$z, $material);
}

sub outer_tower {
    my ($dx, $dz) = @_;
    for my $y (-14..8) {
        for my $x (1..7) {
            for my $z (1..7) {
                setblock($x+$dx, $y, $z+$dz, 'cobblestone');
            }
        }
        for my $x (2..6) {setblock($x+$dx, $y, $dz, 'cobblestone');}
        for my $x (2..6) {setblock($x+$dx, $y, 8+$dz, 'cobblestone');}
        for my $z (2..6) {setblock($dx, $y, $z+$dz, 'cobblestone');}
        for my $z (2..6) {setblock(8+$dx, $y, $z+$dz, 'cobblestone');}
    }

    for my $y (0..8) {
        for my $x (3..5) {
            for my $z (3..5) {
                setblock($x+$dx, $y, $z+$dz, 'air');
            }
        }
    }
}

sub outer_gatehouse {
    my ($dx, $dz) = @_;
    for my $y (-14..8) {
        for my $x (0..8) {
            for my $z (0..10) {
                setblock($x+$dx, $y, $z+$dz, 'cobblestone');
            }
        }
        for my $x (1..7) {setblock($x+$dx, $y, 11+$dz, 'cobblestone');}
        for my $x (2..6) {setblock($x+$dx, $y, 12+$dz, 'cobblestone');}
    }

    for my $y (0..8) {
        for my $x (3..5) {
            for my $z (3..9) {
                setblock($x+$dx, $y, $z+$dz, 'air');
            }
        }
    }
}

sub inner_tower {
    my ($dx, $dz) = @_;
    for my $y (-3..14) {
        for my $x (5..9) { setblock($x+$dx, $y, 0+$dz, 'cobblestone'); }
        for my $x (3..11) { setblock($x+$dx, $y, 1+$dz, 'cobblestone'); }
        for my $x (2..12) { setblock($x+$dx, $y, 2+$dz, 'cobblestone'); }
        for my $x (1..13) { setblock($x+$dx, $y, 3+$dz, 'cobblestone'); }
        for my $x (1..13) { setblock($x+$dx, $y, 4+$dz, 'cobblestone'); }
        for my $x (0..14) { setblock($x+$dx, $y, 5+$dz, 'cobblestone'); }
        for my $x (0..14) { setblock($x+$dx, $y, 6+$dz, 'cobblestone'); }
        for my $x (0..14) { setblock($x+$dx, $y, 7+$dz, 'cobblestone'); }
        for my $x (0..14) { setblock($x+$dx, $y, 8+$dz, 'cobblestone'); }
        for my $x (0..14) { setblock($x+$dx, $y, 9+$dz, 'cobblestone'); }
        for my $x (1..13) { setblock($x+$dx, $y, 10+$dz, 'cobblestone'); }
        for my $x (1..13) { setblock($x+$dx, $y, 11+$dz, 'cobblestone'); }
        for my $x (2..12) { setblock($x+$dx, $y, 12+$dz, 'cobblestone'); }
        for my $x (3..11) { setblock($x+$dx, $y, 13+$dz, 'cobblestone'); }
        for my $x (5..9) { setblock($x+$dx, $y, 14+$dz, 'cobblestone'); }
    }
    for my $y (0..14) {
        for my $x (6..8) { setblock($x+$dx, $y, 4+$dz, 'air'); }
        for my $x (5..9) { setblock($x+$dx, $y, 5+$dz, 'air'); }
        for my $x (4..10) { setblock($x+$dx, $y, 6+$dz, 'air'); }
        for my $x (4..10) { setblock($x+$dx, $y, 7+$dz, 'air'); }
        for my $x (4..10) { setblock($x+$dx, $y, 8+$dz, 'air'); }
        for my $x (5..9) { setblock($x+$dx, $y, 9+$dz, 'air'); }
        for my $x (6..8) { setblock($x+$dx, $y, 10+$dz, 'air'); }
    }
}

sub inner_gatehouse {
    my ($dx, $dz) = @_;
    for my $y (-3..14) {
        for my $x (0..14) {
            for my $z (0..20) {
                setblock($x+$dx, $y, $z+$dz, 'cobblestone');
            }
        }
        for my $x (1..13) { setblock($x+$dx, $y, 21+$dz, 'cobblestone'); }
        for my $x (1..13) { setblock($x+$dx, $y, 22+$dz, 'cobblestone'); }
        for my $x (2..12) { setblock($x+$dx, $y, 23+$dz, 'cobblestone'); }
        for my $x (3..11) { setblock($x+$dx, $y, 24+$dz, 'cobblestone'); }
        for my $x (5..9) { setblock($x+$dx, $y, 25+$dz, 'cobblestone'); }
    }
    for my $y (0..14) {
        for my $x (3..11) {
            for my $z (4..9,12..16) {
                setblock($x+$dx, $y, $z+$dz, 'air');
            }
        }
        for my $x (4..10) { setblock($x+$dx, $y, 17+$dz, 'air'); }
        for my $x (4..10) { setblock($x+$dx, $y, 18+$dz, 'air'); }
        for my $x (4..10) { setblock($x+$dx, $y, 19+$dz, 'air'); }
        for my $x (5..9) { setblock($x+$dx, $y, 20+$dz, 'air'); }
        for my $x (6..8) { setblock($x+$dx, $y, 21+$dz, 'air'); }
    }
}

sub spiral_stairs {
    my ($dx, $dz) = @_;
    for my $y (-3..20) {
        for my $x (1..3) {
            for my $z (0..4) {
                setblock($x+$dx, $y, $z+$dz, 'cobblestone');
           }
        }
        for my $x (0,4) {
            for my $z (1..3) {
                setblock($x+$dx, $y, $z+$dz, 'cobblestone');
           }
        }
    }

    for my $y (0..22) {
        for my $x (1..3) {
            for my $z (1,3) {
                setblock($x+$dx, $y, $z+$dz, 'air');
           }
        }
        setblock(1+$dx, $y, 2+$dz, 'air');
        setblock(3+$dx, $y, 2+$dz, 'air');
    }
}
