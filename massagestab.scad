// parameters
l = 127; // length of the shaft
sr1 = 15; // shaft radius 1
sr2 = 10; // shaft radius 2
kr1 = sr2 *1.1;
kr2 = sr2 *0.8;

br1 = 30; // base radius 1
br2 = sr1; // base radius 2
bh = 11; // base height
module schaft() {
    // body...
    cylinder(h=l, r1=sr1, r2=sr2, center=true);
    minkowski() {
        translate([0,0,l/2])
        cylinder(h=30, r1=kr1, r2=kr2, center=true);
        sphere(r=5);
    }
}

module basis() {
    // body...
    cylinder(h=bh, r1=br1, r2=br2, center=true);
    
}

module massageStab() {
    union() {
        translate([0,0,l/2])
            schaft();
        basis();
    }
}

massageStab();
