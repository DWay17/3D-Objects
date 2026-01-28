//
$fn = $preview ? 16 : 24;

base_h = 2.5;
base_d = 90 + 0.1;

border_d = base_d - 9.5;
border_w = 2.9;
border_h = 15;
place_d = 23;

tower_d = base_d/2 + 0 * 1.3 * border_w;
tower_h = 78;
cos30 = cos(30);
echo(str("cos30=", cos30));
//tower_x = sin(60) * base_d/4 - border_w*3;
tower_x = base_d/2 - tower_d/2 - (base_d - border_d)/2 - border_w/2 - 0.9;
//tower_x = base_d/2 - tower_d/2 - (border_d - border_w)/2;
tower_y = cos(60) * tower_x;
obs_h = tower_d/3 - 3.12 * border_w;
obs_bs1 = 7.2;
obs_bs2 = 1.1;

rut_h = tower_d/2*cos30;
rut_b = tower_d / 1 + cos30;

rem_out_pla_inner_x = +07.8;
rem_out_pla_outer_y = -16.4;

tri_h  = 25;
tri_d2 = tower_d + 30;

// base 
cylinder(h=base_h, d=base_d, center=true, $fn=6);

// border 
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
        cylinder(h=border_h, d=place_d - 0 * border_w, $fn=6);
    }
    
}
// place_bordes
translate([0, 0, base_h/2])
difference(){
    for (i = [0:5]){
        rotate(i * 60)
        translate([ (border_d/2 - 0*place_d/2 + 1*border_w), 0, 0])
        cylinder(h = border_h, d=place_d + 0 * border_w, $fn=6);
    }
    remove_place_outside(border_d/2 - 0*place_d/2 + 1*border_w, 0, 5, 0, 0, false);
    difference() {
        cylinder(h = border_h, d=base_d + place_d, $fn=6);
        //cylinder(h = border_h, d=base_d - 3.45 * border_w, $fn=6);
        cylinder(h = border_h, d=border_d, $fn=6);
    }
}

module remove_place_outside(trans_x, from, to, inner_x, outer_y, move_first_turn_then) {
    for (i = [from:to]){
        if (move_first_turn_then) {
            translate([0, outer_y, 0])
            rotate(i * 60)    
            translate([trans_x + inner_x, 0 , 0])
            cylinder(h = border_h, d=place_d - 1 * border_w, $fn=6);
    } else {
            rotate(i * 60)
            translate([trans_x + inner_x, 0 , 0])
            cylinder(h = border_h, d=place_d - 1 * border_w, $fn=6);
        }
    }
}

// tower0
rotate(30)
translate([0, 0, base_h/2])
translate([tower_x, 0, 0])
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
        obstacles();
        // tbc
        rotate(120)
        translate([0, -tower_d/2, border_h/2])
        cube([tower_d/2*cos30 + border_w, 
          cos30*
          (border_d/2 - tower_d/2 - border_w )/2, 
          border_h], true);

        rotate(60)
        translate([0, tower_d/2, border_h/2])
        cube([tower_d/2*cos30 + border_w,
          cos30*
          (border_d/2 - tower_d/2 - border_w )/2, 
          border_h], true);
        // rutsche
        translate([0, tower_d/2 - rut_h/2 - border_w - 1, rut_h/2 - 0])
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
    translate([0, - tower_d/2 - 6.9, 6])
    rotate([27])
    cube([tower_d * 2, tower_d, tower_d], center=true);
    // remove inside
    /*  
    difference(){ // XXX: needed ???
        cylinder(h=border_h, d=tower_d - border_w, $fn=6);
        translate([0, tower_d/2-7, base_h*4])
        cube([30, 6, border_h], true);
    } */
    // remove all outside
    translate([0, 0, border_h])
    linear_extrude(height = tower_h - border_h)
    difference()
    {
        circle(d=tower_d + 10 * border_w, $fn=6);
        circle(d=tower_d + 0 * border_w, $fn=6);    
    }
    // TODO: move_first_turn_then
    remove_place_outside(tower_d/2 + place_d/2, 1, 2, rem_out_pla_inner_x, rem_out_pla_outer_y, true);
}

module obstacles(height, rotate){
    echo(str("module obstacles (height, rotate)=", height, rotate));
    obstacle(37 + rands(-3, +3, 1)[0], 0 * 60 + rands(-3, +3, 1)[0]);
    obstacle(47 + rands(-3, +3, 1)[0], 3 * 60 + rands(-3, +3, 1)[0]);
    obstacle(49 + rands(-3, +3, 1)[0], 4 * 60 + rands(-3, +3, 1)[0]);
    obstacle(58 + rands(-3, +3, 1)[0], 1 * 60 + rands(-3, +3, 1)[0]);
    obstacle(65 + rands(-3, +3, 1)[0], 5 * 60 + rands(-3, +3, 1)[0]);
    obstacle(73 + rands(-3, +3, 1)[0], 2 * 60 + rands(-3, +3, 1)[0]);
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

