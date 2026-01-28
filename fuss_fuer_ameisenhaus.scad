h1  = 3.4;
i_x = 180;
i_y = 70;

spielraum = 0.5;

b = 10;
a_x = i_x + b*2;
a_y = i_y + 70;
f = 1.01;
kl_x = b*4;
kl_y = b*2;

difference () {
    union () {
        cube([a_x, a_y, h1*2], true);
    }
    translate([0, 0, h1 - 0.666])
    cube([i_x + spielraum, i_y + spielraum, h1 + 2], true);

    translate([0, 0, 0])
    cube([i_x - b, i_y - b, h1 * 4], true);

    translate([0, i_y/2 + a_y/2 - b*1, 0])
    cube([i_x, i_y, h1*2.5], true);

    translate([0, -i_y/2 - a_y/2 + b*1, 0])
    cube([i_x, i_y, h1*2.5], true);

    // 
    translate([a_y/2, a_x/2 - kl_x/2 - 2.5 * b,  0 ])
    cube([f*b, f*b, f*b], true);

    translate([-a_y/2, a_x/2 - kl_x/2 - 2.5 * b,  0 ])
    cube([f*b, f*b, f*b], true);
 
    translate([a_y/2, -a_x/2 + kl_x/2 + 2.5 * b,  0 ])
    cube([f*b, f*b, f*b], true);
 
    translate([-a_y/2, -a_x/2 + kl_x/2 + 2.5 * b,  0 ])
    cube([f*b, f*b, f*b], true);
    // 

    translate([a_y/2, a_x/2 - kl_x/2 - 4 * b,  -h1/2])
    cube([f * b, f * kl_x - b,  f * h1*1 + spielraum], true);

    translate([-a_y/2, a_x/2 - kl_x/2 - 4 * b, -h1/2])
    cube([f * b, f * kl_x - b,  f * h1*1 + spielraum], true);

    translate([a_y/2, -a_x/2 + kl_x/2 + 4 * b, -h1/2])
    cube([f * b, f * kl_x - b,  f * h1*1 + spielraum], true);

    translate([-a_y/2, -a_x/2 + kl_x/2 + 4 * b, -h1/2])
    cube([f * b,,f * kl_x - b,  f * h1*1 + spielraum], true);


}

module klemme() {
    difference(){
        cube([kl_x, b, h1*3], true);
        translate([-b, 0, 0])
        cube([f * kl_x, f * b, f * h1*1], true);

    }
}

translate([a_x * 0.66, kl_y, h1/3*2])
klemme();
translate([-a_x * 0.66, kl_y, h1/3*2])
klemme();
translate([a_x * 0.66, -kl_y, h1/3*2])
klemme();
translate([-a_x * 0.66, -kl_y, h1/3*2])
klemme();

