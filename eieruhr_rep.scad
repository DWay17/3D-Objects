
l = 15.9;
b = 21;
d = 3.0;
ausparung_x = 2.5;
ausparung_y = 4.3;
cyl_r = 25;
cyl_t_x = 9.5;
cyl_t_y = 0;
cyl_t_z = cyl_r - d/2 + 0.2;
// pyramidebstumpf mit rechteckiger grundfläche
p_boden_b = 0.7;
p_boden_l = 0.9;
p_dach_b = 0.5;
p_dach_l = 0.7;
p_hoehe = 1.8;
p_t_x = - l/2 + p_boden_l/2 + 1 * 1.0;
p_t_y = -b/2 + p_boden_b/2  + 1 * 1.0;
p_t_z= d/2 - 0.2;
polyhedron_points = [
    [p_boden_l/2, p_boden_b/2, 0],    // 0 unten vorne rechts
    [-p_boden_l/2, p_boden_b/2, 0],   // 1 unten vorne links
    [-p_boden_l/2, -p_boden_b/2, 0],  // 2 unten hinten links
    [p_boden_l/2, -p_boden_b/2, 0],   // 3 unten hinten rechts
    [p_dach_l/2, p_dach_b/2, p_hoehe],    // 4 oben vorne rechts
    [-p_dach_l/2, p_dach_b/2, p_hoehe],   // 5 oben vorne links
    [-p_dach_l/2, -p_dach_b/2, p_hoehe],  // 6 oben hinten links
    [p_dach_l/2, -p_dach_b/2, p_hoehe]    // 7 oben hinten rechts
];
polyhedron_faces = [
    [0, 1, 2, 3], // Boden
    [4, 5, 6, 7], // Dach
    [0, 4, 7, 3], // Seite rechts
    [1, 5, 6, 2], // Seite links
    [0, 1, 5, 4], // Seite vorne
    [3, 2, 6, 7]  // Seite hinten
];

//debug = true;
debug = false;
$fn = 64;
union() {
    
    difference() {
        cube([l, b, d], center=true);
        translate([cyl_t_x, cyl_t_y, cyl_t_z])
        rotate([90, 0, 0])
        cylinder(h=b*1.01, r=cyl_r, center=true);
        translate([-l/2 + ausparung_x/2, b/2 - ausparung_y/2, 0])
        cube([ausparung_x*1.01, ausparung_y*1.01, d*1.01], center=true);
    }
    
    translate([p_t_x, p_t_y, p_t_z])
    polyhedron(points = polyhedron_points, faces = polyhedron_faces);
}

if (debug) {
    translate([cyl_t_x, cyl_t_y, cyl_t_z])
    rotate([90, 0, 0])
    cylinder(h=b*1.01, r=cyl_r, center=true);
    translate([-l/2 + ausparung_x/2, b/2 - ausparung_y/2, 0])
    cube([ausparung_x*1.01, ausparung_y*1.01, d*1.01], center=true);
}
