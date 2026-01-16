// Stiftköcher: Innenbecher + oben offener Außenring
// mit radialen Kompartimenten innen und außen
// Version 2.5

// --- Parameter ---
inner_diameter         = 93;		// Innendurchmesser des Hauptfachs (mm)
inner_height           = 123;		// Höhe des Innenbechers (mm)

outer_ring_width       = 16.5;		// Breite des äußeren Rings (mm)
outer_height           = 90;		// Höhe des äußeren Rings/Fächer (mm)

wall_thickness         = 2.5;		// Wandstärke (innen und außen)
bottom_thickness       = 3;		// Bodenstärke (mm)

inner_compartments     = 3;		// Anzahl der Innenfächer
inner_wall_thickness   = 1.7;		// Dicke der Trennwände innen (mm)
inner_hub_radius       = 0;		// Radius der zentralen Nabe innen (mm), 0 für ohne Nabe
                            	
outer_compartments     = 7;		// Anzahl der Außenfächer
outer_wall_thickness   = 2;		// Dicke der Trennwände außen (mm)

compartment_height_adjust = -5;	// Höhenanpassung der Fächer (mm), z.B. -5 für niedrigere Fächer
minkowski_radius      = 2;			// Radius für Minkowski-Rundungen (mm), 0 = keine Rundung

top_chamfer            = 9;		// kleine Fase oben (mm), 0 = keine

$fn = 64;							// Rundungen fein

inner_r      = inner_diameter/2;
outer_r_in   = inner_r + wall_thickness;	// innerer Radius des Außenrings
outer_r_out  = outer_r_in + outer_ring_width + wall_thickness;	// äußerer Radius des Außenrings

// --- Hauptmodul ---
module pen_holder() {

    // Alles als ein zusammenhängender Körper ausgeben
    union() {
        // Außenring
       // outer();
        // Innenbecher
        inner();        
    }
}

module inner_cyl(){
    difference() {
        union() {
            cylinder(h = inner_height, r = inner_r + wall_thickness);
            if (top_chamfer > 0)
                translate([0,0,inner_height - top_chamfer])
                    cylinder(h = top_chamfer,
                                r1 = inner_r + wall_thickness,
                                r2 = inner_r + wall_thickness - top_chamfer);
        }
        // Innenaushöhlung bis knapp unter den Rand -> oben offen
        translate([0,0,bottom_thickness])
            cylinder(h = inner_height - bottom_thickness, r = inner_r);
    }
}

module outer_cyl() {
    difference() {
        cylinder(h = outer_height, r = outer_r_out);
        // Innenaushöhlung des Rings bis knapp unter den Rand -> oben offen
        translate([0,0,bottom_thickness])
            cylinder(h = outer_height - 0*bottom_thickness + 50, r = outer_r_in + outer_ring_width);
    }
}

module inner() {
    if (minkowski_radius > 0) {
        minkowski() {
            inner_cyl();
            sphere(minkowski_radius);
        }
    } else {
        inner_cyl();
    }
    inner_radial_dividers(inner_r, inner_height);
}

module outer() {    
    if (minkowski_radius > 0) {
        minkowski() {
            outer_cyl();
            sphere(minkowski_radius);
        }
    } else {
        outer_cyl();
    }
    outer_radial_dividers(outer_r_in, outer_ring_width, outer_height);
}

// --- Innen: radiale Trennwände ---
module inner_radial_dividers(r_in, h) {
    // Optionale Nabe für Stabilität
    if (inner_hub_radius > 0)
        translate([0,0,bottom_thickness])
            cylinder(h = h - bottom_thickness, r = inner_hub_radius);

    for (i = [0:inner_compartments-1]) {
        angle = 360/inner_compartments * i;
        rotate([0,0,angle])
            translate([max(inner_hub_radius, 0), -inner_wall_thickness/2, bottom_thickness])
                cube([ r_in - max(inner_hub_radius, 0), inner_wall_thickness, h - bottom_thickness + compartment_height_adjust]);
    }
}

// --- Außen: radiale Trennwände im Ring ---
module outer_radial_dividers(r_in, ring_w, h) {
    for (i = [0:outer_compartments-1]) {
        angle = 360/outer_compartments * i;
        rotate([0,0,angle])
            translate([r_in, -outer_wall_thickness/2, bottom_thickness])
                cube([ ring_w, outer_wall_thickness, h - bottom_thickness +compartment_height_adjust]);
    }
}

// --- Aufruf ---
pen_holder();
