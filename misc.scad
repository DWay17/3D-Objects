
module regular_polygon(order = 4, r=1){
     angles=[ for (i = [0:order-1]) i*(360/order) ];
     coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
     polygon(coords);
 }

module hollow_sphere_cube(dia, x=1, y=0, z=0, fac=1.2) {
    cube_size = fac * dia;
    difference() {

        cube(cube_size, true);

        sphere(d=dia, $fn=32);
        if (x != 0) {
            translate([x*cube_size/2, 0, 0])
            cube(cube_size * 1.001, true);
        }
        if (y != 0) {
            translate([0, y*cube_size/2, 0])
            cube(cube_size * 1.001, true);
        }
        if (z != 0) {
            translate([0, 0, z*cube_size/2])
            cube(cube_size * 1.001, true);
        }
    }
}

module hollow_sphere_sphere(dia, x=1, y=0, z=0, fac=1.2) {
    sphere_size = fac * dia;
    difference() {
        sphere(d=sphere_size, $fn=32);

        sphere(d=dia, $fn=32);
        if (x != 0) {
            translate([x*sphere_size/2, 0, 0])
            cube(sphere_size * 1.001, true);
        }
        if (y != 0) {
            translate([0, y*sphere_size/2, 0])
            cube(sphere_size * 1.001, true);
        }
        if (z != 0) {
            translate([0, 0, z*sphere_size/2])
            cube(sphere_size * 1.001, true);
        }
    }
}

// hollow_sphere_cube(10, 1, 0, 0);
// hollow_sphere_sphere(10, 1, 0, 0);
