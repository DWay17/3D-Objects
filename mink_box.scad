
module mink_box(x, y, z, w, mk){
    f = 1.005;
    xx = x - 1 * mk;
    yy = y - 1 * mk;
    zz = z -     mk/2;

*    
    cube([x, y, z], true);

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

module half_sphere(dia, ud) {
    difference()
    {
        sphere(d=dia);
        translate([0, 0, ud * dia/2])
        cube(dia, true);
    }
}
//$fn = 32;
//mink_box(60, 10, 120, 3, 0.5);
