// Stiftköcher mit geschlossenem Innenbecher + geschlossenem Außenring mit Fächern
// Version 2.3

// --- Parameter ---
inner_diameter       = 60;   // Durchmesser des inneren Hauptfachs (mm)
inner_height         = 90;   // Höhe des inneren Hauptfachs (mm)

outer_ring_width     = 20;   // Breite des äußeren Ringes (mm)
outer_height         = 60;   // Höhe der äußeren Fächer + äußerer Rand (mm)

wall_thickness       = 3;    // Wandstärke (innen und außen)
bottom_thickness     = 3;    // Bodenstärke (mm)

outer_compartments   = 3;   // Anzahl der schmalen Außenfächer
outer_wall_thickness = 2;    // Dicke der Zwischenwände außen (mm)

$fn = 32; // Glätte für Rundungen

// --- Hauptmodul ---
module pen_holder() {
    inner_r = inner_diameter/2;
    outer_r_in  = inner_r + wall_thickness;
    outer_r_out = outer_r_in + outer_ring_width;

    // 1) Innenbecher mit geschlossenem Rand
    difference() {
        cylinder(h = inner_height, r = inner_r + wall_thickness);
        translate([0,0,bottom_thickness])
            cylinder(h = inner_height - bottom_thickness, r = inner_r);
    }

    // 2) Geschlossener Außenring
    difference() {
        cylinder(h = outer_height, r = outer_r_out);
        translate([0,0,bottom_thickness])
            cylinder(h = outer_height - bottom_thickness, r = outer_r_in);
    }

    // 3) Radiale Trennwände im Außenring
    for (i = [0:outer_compartments-1]) {
        angle = 360/outer_compartments * i;
        rotate([0,0,angle])
            translate([outer_r_in, -outer_wall_thickness/2, bottom_thickness])
                cube([outer_ring_width, outer_wall_thickness, outer_height - bottom_thickness]);
    }
}

// --- Aufruf ---
pen_holder();
