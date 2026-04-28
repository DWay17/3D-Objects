//$fn = 16;

module mink_cube(x, y, z, mk, up, dw){
    f = 1.005;
    xx = x -     1 * mk;
    echo(str("xx = ", xx));
    yy = y -     1 * mk;
    echo(str("yy = ", yy));
    zz = z - 1 * up * mk/2 - 1 * dw * mk/2;
    echo(str("zz = ", zz));
    tr_z = up * mk/4 - dw * mk/4;

    //%translate([0, 0, tr_z])
    *
    cube([x, y, z], true);
    
    translate([0, 0, tr_z])
        minkowski() {
            cube([xx, yy, zz], true);
            union(){
                half_sphere(up * mk, 1);
                half_sphere(dw * mk, -1);
            }
        }
}

module half_sphere(dia, ud) {
    difference()
    {
        sphere(d=dia);
        translate([0, 0, ud * dia/2])
        cube(dia, true);
    }
}

//mink_cube(10,20,40, 1 * 2.5, 1, 1);
