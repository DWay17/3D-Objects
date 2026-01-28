// AMS Universal Small Spool Adapter v2 Washer 

diam_a = 115;
height = 1.5;
border = 15;

diam_i = 40 + 5;

union(){
    difference () {
        cylinder(h=height, d=diam_a);
        cylinder(h=height, d=(diam_a - border)*1.05);
    }
    difference () {
        cylinder(h=height, d=diam_i + border);
        cylinder(h=height, d=diam_i * 1.05);
    }
    for (i = [0:5]) {
        rotate(i * 60)
        translate([diam_a/2 - diam_i/2 + border/2, 0, height/2])
        cube([diam_a/2 - diam_i/2 - border/2, border/2, height], true);
    }
}


