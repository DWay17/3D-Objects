//
$fn = $preview ? 16 : 32;

base_h = 2.5;
base_d = 90 + 0.1;

border_d = base_d - 9.5;
border_w = 2.9;
border_h = 15;
place_d = 23;

tower_d = base_d/2 + 0 * 1.3 * border_w;
tower_h = 78;
tower_x = sin(60) * base_d/4 - border_w*3;
tower_y = cos(60) * tower_x;
cos30 = cos(30);
echo(str("cos30=", cos30));
obs_h = tower_d/3 - 3.12 * border_w;
obs_bs1 = 7.2;
obs_bs2 = 1.1;

rut_h = tower_d/2*cos30;
rut_b = tower_d / 1 + cos30;

tri_h  = 25;
tri_d2 = tower_d + 30;

// base
%cylinder(h=base_h, d=base_d, center=true, $fn=6);

// border
%translate([0, 0, base_h/2])
translate([0, 0, base_h/2])
difference(){
    union () {
        cylinder(h=border_h, d=border_d, $fn=6);
    }
    // remove inner to get border
    cylinder(h=border_h, d=border_d - border_w,  $fn=6);
    // remove 6 places
    for (i = [0:5]){
        rotate(i * 60)
        translate([ (border_d/2 - 0*place_d/2 + 1*border_w), 0, 0])
        cylinder(h=border_h, d=place_d-0*border_w, $fn=6);
    }
    
}
// place_bordes
%translate([0, 0, base_h/2])
difference(){
    for (i = [0:5]){
        rotate(i * 60)
        translate([ (border_d/2 - 0*place_d/2 + 1*border_w), 0, 0])
        cylinder(h = border_h, d=place_d + 0 * border_w, $fn=6);
    }
    remove_place_outside();
    difference() {
        cylinder(h = border_h, d=base_d + place_d, $fn=6);
        cylinder(h = border_h, d=base_d - 3.45 * border_w, $fn=6);
    }
}

module remove_place_outside() {
    for (i = [0:5]){
        rotate(i * 60)
        translate([ (border_d/2 - 0*place_d/2 + 1*border_w), 0, 0])
        cylinder(h = border_h, d=place_d - 1 * border_w, $fn=6);
    }
}

// tower
rotate(30)
translate([0, 0, base_h/2])
translate([base_d/2 - place_d - border_w * 3.03, 0, 0])
rotate(270)
difference(){
    union() {
        //linear_extrude(height = tower_h)
        union(){                                        
            difference(){
                cylinder(h=tower_h, d=tower_d, $fn=6);
                cylinder(h=tower_h + 3, d=tower_d - border_w, $fn=6);
            }
        }                                               
        // obstacles                                    
        obstacle(27 + rands(-3, +3, 1)[0], 0 * 60 + rands(-3, +3, 1)[0]);
        obstacle(42 + rands(-3, +3, 1)[0], 3 * 60 + rands(-3, +3, 1)[0]);
        obstacle(47 + rands(-3, +3, 1)[0], 4 * 60 + rands(-3, +3, 1)[0]);
        obstacle(53 + rands(-3, +3, 1)[0], 1 * 60 + rands(-3, +3, 1)[0]);
        obstacle(60 + rands(-3, +3, 1)[0], 5 * 60 + rands(-3, +3, 1)[0]);
        obstacle(70 + rands(-3, +3, 1)[0], 2 * 60 + rands(-3, +3, 1)[0]);
        // tbc
        translate([tower_d/2 - 10.4, 4.2, 0])
        rotate(0)
        cube([10, 10, border_h]);
        translate([tower_d/2 - 5, 1, 0])
        rotate(30)
        cube([10, 10, border_h]);

        translate([-tower_d/2 + 0.4, 4.2, 0])
        rotate(0)
        cube([10, 10, border_h]);
        translate([-tower_d/2 + 5, 1, 0])
        rotate(60)
        cube([10, 10, border_h]);
        // rutsche
        translate([0, tower_d/2  - rut_h/2 - border_w, rut_h/2 - 0])
        rotate([0, 90, 180])
        difference() {
            cube([rut_h,rut_h,rut_b], true);
            translate([-rut_h/2, rut_h/2, 0])
            cylinder(h=rut_b, r=rut_h, center=true);
            translate([0, 0, border_h])
            linear_extrude(height = tower_h - border_h)
            difference()
            {
                circle(d=tower_d + 10*border_w, $fn=6);
                circle(d=tower_d + 0.5 * border_w, $fn=6);    
            }
        }
        // trichter
        translate([0, 0, tower_h])
        trichter();
    }
    // auslass
    translate([0, - tower_d/2 - 5, 2.7])
    rotate([30])
    cube([tower_d * 2, tower_d, tower_d], center=true);
    // remove inside
    difference(){
        cylinder(h=border_h, d=tower_d - border_w, $fn=6);
        translate([0, tower_d/2-7, base_h*4])
        cube([30, 6, border_h], true);
    }
    // remove all outside
    translate([0, 0, border_h])
    linear_extrude(height = tower_h - border_h)
    difference()
    {
        circle(d=tower_d + 10*border_w, $fn=6);
        circle(d=tower_d + 0.5 * border_w, $fn=6);    
    }
}

module obstacle(height, rotate) {
    rotate(rotate)
    translate([0, tower_d/2 - 1.5 * border_w - obs_h/2, height])
    rotate([90, 0, 0])
    cylinder(h=obs_h, d1=obs_bs1, d2=obs_bs2, center=true);    
}

module trichter() {
    difference()
    {
        cylinder(h=tri_h, d1=tower_d, d2=tri_d2, $fn = 6);
        translate([00, 0, -border_w/2])
        cylinder(h=tri_h + border_w*1, d1=tower_d - 2*border_w - 0.1, d2=tri_d2 - border_w, $fn = 6);
    }
}

