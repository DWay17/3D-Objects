// besteckfach_kuchengabeln

$fn = $preview ? 16 : 32;

mk = 1 * 3.1415;
mk_h = 0.0001;

f = 1.01;                   // factor for cut

w = 1.5;

a_o_x = 210         - 0;
a_o_y = 60          - 0;
a_h   = 42   + w    - 0;

r_x_a = 15;
r_y_a = 17.5;
r_x = a_o_x + r_x_a - 0;
r_y = a_o_y + r_y_a - 0;
r_h = 1.5           - 0;

// fork
f_h = a_h;

// scraper 95 47 17
sc_x = 107           - 0;
sc_y = 17            - 0;
sc_h = a_h ;

//#cylinder(h=mk_h, d=mk);


module border () {
    difference(){
        minkowski()
        {
            translate([0, -r_y_a/4, 0])
            cube([r_x - mk/2, r_y - mk/2, r_h], true);
            cylinder(h=mk_h, d=mk);
        }
        minkowski(){
            translate([0, 0, 0])
            cube([a_o_x - mk, a_o_y - mk, r_h*f], true);
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
    translate([0, 0, -f_h/2])
    box(a_o_x, a_o_y, f_h, w, mk);
}

difference(){
    union(){

        translate([0, 0, -w/2]) 
        border();

        translate([0, a_o_y/2 - sc_y/2, 0]) 
        scraper();

        fork();

        translate([a_o_x/2 - sc_x -w/2, a_o_y/2 - w - 0.5, -sc_h/2 + w/2])
        difference(){
            cube([mk, mk, sc_h - w], true);
            translate([-mk/2, -mk/2, 0])
            cylinder(h=sc_h*f, d=mk, center = true);
        }

        echo(str("w + w/8 = ", w + w/8));
        translate([a_o_x/2 - sc_x -w/2, a_o_y/2 - sc_y/2,
                   -sc_h + w + 0.2])
        rotate([-90,0,0])
        difference(){
            //echo(str("sc_y - w*2 = ", sc_y - w*2));
            cube([mk, mk, sc_y - w*2], true);
            translate([-mk/2, -mk/2, 0])
            cylinder(h=sc_h*f, d=mk, center = true);
        }

        translate([a_o_x/2 - sc_x/2, a_o_y/2 - sc_y, -sc_h + w + 0.2])
        rotate([0,90,0])
        difference(){
            cube([mk, mk, sc_x - w*1], true);
            translate([-mk/2, -mk/2, 0])
            cylinder(h=sc_x*f, d=mk, center = true);
        }

        translate([a_o_x/2 -w - 0.5, a_o_y/2 - sc_y, -sc_h/2 + w/2])
        difference(){
            cube([mk, mk, sc_h -w ], true);
            translate([-mk/2, -mk/2, 0])
            cylinder(h=sc_h*f, d=mk, center = true);
        }

        translate([a_o_x/2 - sc_x - w/2 , 
                    a_o_y/2 - sc_y,
                    -sc_h + 2*w + 0.29])
        difference(){
            cube([mk, mk, mk*f], true);

            translate([0, 0, mk/2])
            cube([mk*f, mk*f, mk*f], true);

            translate([-mk/2, -mk/2, 0])
            rotate([0, 90,0])
            cylinder(h=sc_h*f, d=mk*f, center = true);

            translate([-mk/2, -mk/2, 0])
            rotate([-90,0,0])
            cylinder(h=sc_h*f, d=mk*f, center = true);
        }

    }
    #
    translate([0, 0, 0])
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

