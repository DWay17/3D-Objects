// cube_r_o.scad
// Variables Rechteck mit Rundung aussen/oben
$fn=50;
// breite = X-Achse
// laenge = Y-Achse
// radius = Höhe & Radius der Rundung

module eckoben (breite, laenge, radius) {
    difference() {
        hull() {
            translate([radius,radius,0])
            sphere(radius);
            translate([breite - radius,radius,0])
            sphere(radius);
            translate([radius, laenge - radius,0])
            sphere(radius);
            translate([breite - radius, laenge - radius,0])
            sphere(radius);
        } // hull
        translate([0,0, -radius])
        cube ([breite, laenge, radius]);
    } // difference
} // module

eckoben (30, 55, 3); // X, Y, Radius oben

