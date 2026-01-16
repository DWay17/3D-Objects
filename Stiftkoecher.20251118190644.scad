// Stiftköcher mit radialem Außenring
// Version 2.0

// --- Parameter ---
inner_diameter   = 60;   // Durchmesser des inneren Hauptfachs (mm)
inner_height     = 90;   // Höhe des inneren Fachs (mm)

outer_ring_width = 20;   // Breite des äußeren Ringes (mm)
outer_height     = 60;   // Höhe des äußeren Ringes (mm)

wall_thickness   = 3;    // Wandstärke außen (mm)
bottom_thickness = 3;    // Bodenstärke (mm)

outer_compartments   = 8;   // Anzahl schmaler Außenfächer
outer_wall_thickness = 2;   // Dicke der Trennwände außen (mm)

$fn = 16 ; // Rundungen fein

// --- Hauptmodul ---
module pen_holder() {
    // Innenzylinder
    difference() {
        cylinder(h = inner_height, r = (inner_diameter/2) + wall_thickness);
        translate([0,0,bottom_thickness])
            cylinder(h = inner_height - bottom_thickness, r = inner_diameter/2);
    }

    // Außenring mit Fächern
    outer_ring();
}

// --- Außenring mit radialen Fächern ---
module outer_ring() {
    outer_radius = (inner_diameter/2) + outer_ring_width + wall_thickness;
    inner_radius = (inner_diameter/2) + wall_thickness;

    // Außenringkörper
    difference() {
        cylinder(h = outer_height, r = outer_radius);
        translate([0,0,bottom_thickness])
            cylinder(h = outer_height - bottom_thickness, r = inner_radius);
    }

    // Radiale Trennwände
    for (i = [0:outer_compartments-1]) {
        angle = 360/outer_compartments * i;
        rotate([0,0,angle])
            translate([inner_radius, -outer_wall_thickness/2, bottom_thickness])
                cube([outer_ring_width, outer_wall_thickness, outer_height - bottom_thickness]);
    }
}

// --- Aufruf ---
pen_holder();
