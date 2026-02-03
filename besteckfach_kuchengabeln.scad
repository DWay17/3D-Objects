// besteckfach_kuchengabeln

$fn = $preview ? 16 : 64;

mk = 12 ;//* 3.1415;
mk_h = 0.0001;

f = 1.01;                   // factor for cut

w = 1.5;

a_o_x = 202.25      - 0;
a_o_y = 60          - 0;
a_h   = 42   + w    - 0;

r_x_a = 12.5 + 6; // 17.55;
r_y_a = 12.5 + 6; // 20.5;
r_x = a_o_x + r_x_a - 0;
r_y = a_o_y + r_y_a - 0;
r_h = 1.5           - 0;

// fork place
f_h = a_h;

// scraper 95 47 17
sc_x = 107           - 0;
sc_y = 20.3          - 0;
sc_h = a_h ;

fl_x = mk/2 + w; // filler


//#cylinder(h=mk_h, d=mk);
co_d = 90 + w * 1.5;

module border () {
    difference(){
        minkowski()
        {
            translate([0, -r_y_a/4, -0])
            cube([r_x - mk/2, r_y - mk/2 - r_y_a/2,
                r_h], true);
            cylinder(h=mk_h, d=mk);
        }
        minkowski(){
            translate([0, 0, -0.2])
            cube([a_o_x - mk - w/2, a_o_y - mk - w/2, r_h*2], true);
            cylinder(h=mk_h, d=mk);
        }
        
    }
}

module box(x, y, z, w, mk){
    xx = x - 1 * mk;
    yy = y - 1 * mk;
    zz = z -     mk/2;
    difference(){
        translate([0, 0, mk/4])
        minkowski() {
            cube([xx, yy, zz], true);
            // sphere(d=mk);
            // cylinder(h=mk_h, d=mk);
            // translate([0, 0, mk/2])
            half_sphere(mk, 1);
        }
        translate([0, 0, f * (w/2 + mk/2)])
        minkowski() {
            cube([xx - 2*w, yy - 2*w, zz - w + mk/2], true);
            half_sphere(mk, 1);
        }
    }
    //#cube([x, y, z], true);
}

module scraper() {
    translate([a_o_x/2 - sc_x/2 - w/4, 0, -sc_h/2])
    box(sc_x + w/2, sc_y, sc_h, w, mk);
}

module fork(){
    translate([0, 0, -f_h/2 + 0.0])
    box(a_o_x, a_o_y, f_h, w, mk);
}

module filler(h) {
    korr = (mk/2 - w/2)/2;
    move = fl_x/2 - korr;
    difference(){

        translate([-move, -move, 0])
        cube([fl_x, fl_x, h], true);

        translate([-mk/2 -korr/2, -mk/2 - korr/2, 0])
        cylinder(h=h*f, d=mk, center = true);
    }
}
//translate([0, 0, -42/2])
//filler(42);

module filler2(h, u) {
    echo(str("w=", w));
    d = sqrt(w^2*2);
    echo(str("d=", d));
    d2 = sqrt(d^2*2);
    echo(str("d2=", d2));
    union(){
        difference() {
            cube([mk/2, mk/2, h], true);

            translate([-mk/4, -mk/4, 0])
            cylinder(h=h*f, d=mk, center = true);
        }
        difference() {
            translate([mk/4 + w/2, 0, 0])
            cube([w, mk/2, h],true);
            if (u) {
                translate([mk/2 - w, 0, h/2])
                rotate([0, 45, 0])
                cube([d, f*mk/2, d], true);
            }
        }
        difference() {
            translate([0, mk/4 + w/2, 0])
            cube([mk/2, w, h],true);
            if (u) {
                translate([0, mk/2 - w, h/2])
                rotate([45, 0, 0])
                cube([mk/2*f, d, d], true);
            }
        }
        difference() {
            translate([mk/4 + w/2, mk/4 + w/2, 0])
            cube([w, w, h],true);
            if (u) {
                x = 0.05;
            
                translate([
                    mk/4 + w/2 + 1*d/2      + x,
                    mk/4 + w/2 + 1*d/2      + x,
                    h/2 + 0*w/2 - 0*d/2     + 0*x
                    ])
                rotate([0, 54, 45])
                cube([2*d, 2*d, 2*d], true);
            }
        }
    }   
}
//translate([0, 0, -42/2])
// filler2(42, true);

difference(){
    union() {

        // border

        translate([0, 0, -w/2 - 0.1]) 
        border();

        // scraper
        
        translate([0, a_o_y/2 - sc_y/2, 0]) 
        scraper();

        // fork
        
        fork();

        // rounder 1
        translate([- w * 2.75,
                    a_o_y/2 + 0*sc_y/2 - 1.3,
                    -sc_h/2 + w*1.5 
                    ])
        cylinder(h = sc_h - w* 3, d = 1.5 * w, center=true);

        translate([a_o_x/2 - sc_x - 2.4 * w ,
                    a_o_y/2 - mk/2 + w - 0.2,
                    -sc_h/2 + w/2 
                    ])
        rotate([0, 180, 270])
        filler2(sc_h - w, true);

        // rounder 2
        
        translate([a_o_x/2 - sc_x - w/2 - 2*w,
                    a_o_y/2 - sc_y/2 + mk/4 - w, 
                   -sc_h + mk/4 + 1*w + 0.3 + 0
                   ])
        rotate([-90,0,0])
        filler2(sc_y - mk/4 - w*2, true);

        // edge filler
        
        translate([a_o_x/2 - sc_x - mk/4 + w + 0.5, 
                    a_o_y/2 - sc_y        - w/2 + 0.5 ,
                    -sc_h + mk/2 + w + 0.2
                    ])
        difference(){
            cube([mk, mk, mk], true);

            translate([0, 0, mk/2])
            cube([mk*f, mk*f, mk*f], true);

            translate([-mk/2, -mk/2, 0])
            rotate([0, 90,0])
            cylinder(h=sc_h*f, d=mk*f, center = true);

            translate([-mk/2 , -mk/2, 0])
            rotate([-90,0,0])
            cylinder(h=sc_h*f, d=mk*f, center = true);

            translate([mk/2 + w, mk/2 + w/2 , 0])
            cylinder(h=sc_h*f, d=mk*f, center = true);

            
            translate([-w -0.5 , -w - 0.5, w/2 + 0.5])
            rotate([90, 0 , 45])
            cylinder(h=sc_h*f, d=mk*f, center = true);

            
            translate([mk/2, mk/2, -mk])
            rotate_extrude(angle = 90)
            translate([-mk, mk, 0])
            circle(d=mk);

        }
        // rounder 3
        
        translate([a_o_x/2 - sc_x/2  + mk/4 - w/2 - 0.9,
                    a_o_y/2 - sc_y    - mk/4 - 0, 
                   -sc_h + mk/4 + w +  + 0.3])
        rotate([0,90,0])
        filler2(sc_x - mk/4 - w*2, true);

        // rounder 4
        translate([a_o_x/2 - w/2 - 0.7,
            (a_o_y-sc_y)/2 - sc_y/2 + w * 1.48,
            -sc_h/2 + w*1.5
            ])
        cylinder(h = sc_h - w*3, d = 1.5 * w, center=true);

        translate([a_o_x/2 + 0 * sc_x/2 - mk/4 - w - 0.15,
                   a_o_y/2  - sc_y  - mk/4,
                            - sc_h/2 + 0*mk/4 + w/2])
        rotate([0, 180, 270])
        filler2(sc_h - w, true);

        // border under cutout
        translate([sc_x/2,
             a_o_y/2 + sc_y / 2 - r_y_a + 5.9 * w ,
             sc_h - 15/2])
        difference() {
            //translate([sc_x/2, a_o_y/2 + sc_y, sc_h - 15/2])
            rotate([90, 0, 0])
            cylinder(h=r_y_a/2 - w - 3.5, d=co_d, center = true);

            //translate([sc_x/2, a_o_y/2 + sc_y, sc_h - 15/2])
            rotate([90, 0, 0])
            cylinder(h=r_x_a, d=90, center = true);
            
            translate([0, 0, 10.12])
            cube([a_o_x, a_o_y, co_d], true);
        }
    }
    
    translate([sc_x/2, a_o_y/2 + sc_y, sc_h - 15/2])
    rotate([90, 0, 0])
    cylinder(h=50, d=90);
}

module half_sphere(dia, ud) {
    difference()
    {
        sphere(d=dia);
        translate([0, 0, ud * dia/2])
        cube(dia, true);
    }
}

//half_sphere(100, 1);
//%box(20, 30, 40, 1.5, 3);

