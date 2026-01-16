// Stiftköcher mit geschlossenem Innenbecher + niedrigem Außenring mit Fächern
// Version 2.2

// --- Parameter ---
inner_diameter       = 60;   // Durchmesser des inneren Hauptfachs (mm)
inner_height         = 90;   // Höhe des inneren Hauptfachs (mm)

outer_ring_width     = 20;   // Breite des äußeren Ringes (mm)
outer_height         = 60;   // Höhe der äußeren Fächer + äußerer Rand (mm)

wall_thickness       = 3;    // Wandstärke (innen und außen)
bottom_thickness     = 3;    // Bodenstärke (mm)

outer_compartments   = 10;   // Anzahl der schmalen Außenfächer
outer_wall_thickness = 2;    // Dicke der Zwischenwände außen (mm)

$fn = 32; // Glätte für Rundungen

// --- Hilfsfunktion: Grad/Rad ---
function rad2deg(a) = a * 180 / PI;

// --- Modul: Ringschneide-Sektor (für Hohlräume der Außenfächer) ---
module ring_sector(r_in, r_out, angle_deg, h) {
    rotate([0,0,-angle_deg/2])  // Zentriere den Sektor
    rotate_extrude(angle = angle_deg, convexity = 10)
        translate([r_in, 0, 0])
            square([r_out - r_in, h], center = false);
}

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

    // 2) Außenring mit niedriger Höhe + Fächern
    difference() {
        // Außenringkörper
        cylinder(h = outer_height, r = outer_r_out);
        translate([0,0,bottom_thickness])
            cylinder(h = outer_height - bottom_thickness, r = outer_r_in);

        // Fächer als ausgesparte Sektoren
        ring_mid_r = (outer_r_in + outer_r_out) / 2;
        wall_angle_deg = rad2deg(outer_wall_thickness / ring_mid_r);
        base_angle_deg = 360 / outer_compartments;
        slot_angle_deg = max(1, base_angle_deg - wall_angle_deg);

        for (i = [0:outer_compartments-1]) {
            angle_center = i * base_angle_deg;
            translate([0,0,bottom_thickness])
                rotate([0,0,angle_center])
                    ring_sector(outer_r_in, outer_r_out, slot_angle_deg, outer_height - bottom_thickness);
        }
    }
}

// --- Aufruf ---
pen_holder();
