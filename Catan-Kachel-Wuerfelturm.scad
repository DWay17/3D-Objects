// final -> 64
$fn = $preview ? 16 : 24;

base_h = 2.5;
base_d = 90 + 0.1;
f = 1.01;

border_d = base_d - 9.5;
border_w = 1.7;
border_h = 15;
place_d = 23;

tower_d = base_d/2 + 0 * 1.3 * border_w;
tower_h = 78;
cos30 = cos(30);
echo(str("cos30=", cos30));
//tower_x = sin(60) * base_d/4 - border_w*3;
tower_x = base_d/2 - tower_d/2 - (base_d - border_d)/2 - border_w/2 - 1.3;
//tower_x = base_d/2 - tower_d/2 - (border_d - border_w)/2;
tower_y = cos(60) * tower_x;
obs_h = tower_d/6 - 0 * 3.12 * border_w;
obs_bs1 = 7.2;
obs_bs2 = 1.1;

rut_h = tower_d/2*cos30;
rut_b = tower_d / 1 + cos30;

r2xy = base_d - place_d + border_w*5;
r2b  = base_d - place_d + border_w*1;

rem_out_pla_inner_x = +07.8;
rem_out_pla_outer_y = -16.4;

tri_h  = 25;
tri_d2 = tower_d + 30;

tri2_h  = border_h/3;
tri2_x  = 10;
tri2_d2 = border_d + tri2_x;

// base 

cylinder(h=base_h, d=base_d, center=true, $fn=6);

// border 

translate([0, 0, base_h/2])
union(){
    difference(){
        union () {
            cylinder(h=border_h, d=border_d, $fn=6);

            translate([0, 0, border_h])
            trichter(tri2_h, border_d, tri2_d2, border_w);
        }
        // remove inner to get border
        cylinder(h=f*(border_h + tri2_h), d=border_d - border_w,  $fn=6);
        // remove 6 places
        for (i = [0:5]){
            rotate(i * 60)
            translate([ (border_d/2 - 0*place_d/2 + 1*border_w), 0, 0])
            cylinder(h=f*(border_h), d=place_d - 0 * border_w, $fn=6);
        }
        
    }
    // rutsche
*    
    difference(){
        
        rotate([0,0,-360/6])
        translate([0, r2xy/4 - border_w*2, 0])
        rotate([0,0,360/6])
        
        rutsche2();
        

        for (i = [-1:2]){
            rotate(i * 60)
            translate([(border_d/2 - 0*place_d/2 + 1*border_w), 0, 0])
            cylinder(h=f*r2xy/2, d=place_d - 0 * border_w, $fn=6);
        }

        remove_outside(f*r2xy/2, border_d);
    }
}

module remove_outside(h, d) {
    difference(){
            cylinder(h=h, d=2*d,  $fn=6);
            cylinder(h=f*h, d=(d - border_w),  $fn=6);
    }
}
// place_bordes
%
translate([0, 0, base_h/2])
difference(){
    
    for (i = [0:5])
    //i=0; // for debug
    {
        rotate(i * 60)
        translate([ (border_d/2 - 0*place_d/2 + 1*border_w), 0, 0])
        union(){
            cylinder(h = border_h, d=place_d + 0 * border_w, $fn=6);

// TODO copy this part to remove of border
            translate([0, 0, border_h])
            trichter(tri2_h, place_d, place_d - tri2_x, border_w);
        }

    }
    remove_place_outside(border_d/2 - 0*place_d/2 + 1*border_w,
        0, 5, 0, 0, false, border_h, place_d);
    remove_place_outside(border_d/2 - 0*place_d/2 + 1*border_w,
        0, 5, 0, 0, false, border_h + tri2_h, place_d - tri2_x);
    difference() {
        cylinder(h = border_h, d=base_d + place_d, $fn=6);
        //cylinder(h = border_h, d=base_d - 3.45 * border_w, $fn=6);
        cylinder(h = f*border_h, d=border_d, $fn=6);
    }
    remove_outside(border_h, border_d);

    translate([0, 0, border_h])
    remove_outside(border_h, border_d + tri2_x);

    // remove tri2 outside
    translate([0, 0, border_h]) 
    difference(){
        cylinder(h=tri2_h, d1=border_d + 7*border_w, d2=tri2_d2 + 9*border_w, $fn = 6);
        cylinder(h=tri2_h, d1=border_d + 0*border_w, d2=tri2_d2 + 0*border_w, $fn = 6);
    }

}

module remove_place_outside(trans_x, from, to, inner_x, outer_y,
    move_first_turn_then, h, d) {
    for (i = [from:to]){
        if (move_first_turn_then) {
            translate([0, outer_y, 0])
            rotate(i * 60)    
            translate([trans_x + inner_x, 0 , 0])
            cylinder(h = f*h, d=d - 1 * border_w, $fn=6);
    } else {
            rotate(i * 60)
            translate([trans_x + inner_x, 0 , 0])
            cylinder(h = f*h, d=d - 1 * border_w, $fn=6);
        }
    }
}

// tower0
*
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
        // tbc();
        //rutsche1();
        
        // trichter
        translate([0, 0, tower_h])
        trichter(tri_h, tower_d, tri_d2, border_w);
    }
    // auslass
    /*
    translate([0, - tower_d/2 - 11.3, 14])
    rotate([20])
    cube([tower_d * 2, 1.05 * tower_d, 1.05 * tower_d], center=true);

    xxx*/
    // auslass2
    
    translate([0, - tower_d/2 - 14, 22])
    rotate([0, 90,0])
    cylinder(h=tower_d*2, d=tower_d * 1.35, center=true);
    // remove inside
    /*  
    difference(){ // XXX: needed ???
        cylinder(h=border_h, d=tower_d - border_w, $fn=6);
        translate([0, tower_d/2-7, base_h*4])
        cube([30, 6, border_h], true);
    } */
    // remove all outside
    translate([0, 0, border_h])
    linear_extrude(height = f*(tower_h - border_h))
    difference()
    {
        circle(d=tower_d + 10 * border_w, $fn=6);
        circle(d=tower_d + 0 * border_w, $fn=6);    
    }
    // TODO: move_first_turn_then
    remove_place_outside(tower_d/2 + place_d/2, 1, 2, rem_out_pla_inner_x, rem_out_pla_outer_y, true, border_h, place_d);
}

module tbc(){
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
}

module rutsche2(){
    translate([0, 0, r2xy/4])
    rotate([0, 0, 360/6*2])
    difference(){
    
        cube([r2b, r2xy/2, r2xy/2], true);
        translate([0, r2xy/4, r2xy/4])
        rotate([0,90,0])
        cylinder(h=r2b*f, d=r2xy, center=true);
    }
}

module rutsche1(){
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

module trichter(h, d1, d2, w) {
    echo(str("d1=", d1));
    echo(str("d2=", d2));
    echo(str("w=", w));
    /* var scope
    d1m = 0;
    d2m = 0;
    z = 0;
    /*/
    if (d1 < d2) { // opening
        echo(str("opening"));
        d1m = w/cos30 - 0.1;
        d2m = w;
        z = -0.01;
        trichter_rest(h, d1, d2, d1m, d2m, z);
    } else { // closing
        echo(str("closing"));
        d1m = w;
        d2m = w/cos30 - 0.1;
        z = -0.01;
        trichter_rest(h, d1, d2, d1m, d2m, z);
    }
}

module trichter_rest(h, d1, d2, d1m, d2m, z){
    echo(str("d1m=", d1m));
    echo(str("d2m=", d2m));
    echo(str("z=", z));
    difference()
    {
        cylinder(h=h, d1=d1, d2=d2, $fn = 6);
        translate([0, 0, z])
        cylinder(h=f*h, 
            d1=d1 - d1m,
            d2=d2 - d2m, $fn = 6);
    }

}

