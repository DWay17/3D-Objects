// Stiftköcher: Innenbecher + äußerer, oben offener Ring
// mit radialen Kompartimenten innen und außen
// Version 2.4

// --- Parameter ---
inner_diameter         = 60;   // Innendurchmesser des Hauptfachs (mm)
inner_height           = 90;   // Höhe des Innenbechers (mm)

outer_ring_width       = 20;   // Breite des äußeren Rings (mm)
outer_height           = 60;   // Höhe des äußeren Rings/Fächer (mm)

wall_thickness         = 3;    // Wandstärke (innen und außen)
bottom_thickness       = 3;    // Bodenstärke (gemeinsam) (mm)

inner_compartments     = 6;    // Anzahl der Innenfächer
inner_wall_thickness   = 2;    // Dicke der Trennwände innen (mm)
inner_hub_radius       = 6;    // Radius der zentralen Nabe innen (mm), 0 für ohne Nabe

outer_compartments     = 10;   // Anzahl der Außenfächer
outer_wall_thickness   = 2;    // Dicke der Trennwände außen (mm)

top_chamfer            = 0;    // kleine Fase oben (mm), 0 = keine

$fn = 128; // Rundungen fein

// --- Hilfsfunktion: Grad/Rad ---
function rad2deg(a) = a * 180 / PI;

// --- Modul: Ringschneide-Sektor (Hilfsform für Aussparungen – hier nicht genutzt) ---
// (gelassen für spätere Erweiterungen)

// --- Hauptmodul ---
module pen_holder() {
    inner_r      = inner_diameter/2;
    outer_r_in   = inner_r + wall_thickness;
    outer_r_out  = outer_r_in + outer_ring_width;

    // 1) Innenbecher: geschlossen (Boden + Wand), oben offen
    difference() {
        union() {
            cylinder(h = inner_height, r = inner_r + wall_thickness);
            if (top_chamfer > 0)
                translate([0,0,inner_height - top_chamfer])
                    cylinder(h = top_chamfer,
                             r1 = inner_r + wall_thickness,
                             r2 = inner_r + wall_thickness - top_chamfer);
        }
        translate([0,0,bottom_thickness])
            cylinder(h = inner_height - bottom_thickness, r = inner_r);
    }

    // 2) Außenring: geschlossen (Boden + Wand), oben offen
    difference() {
        cylinder(h = outer_height, r = outer_r_out);
        translate([0,0,bottom_thickness])
            cylinder(h = outer_height - bottom_thickness, r = outer_r_in);
    }

    // 3) Radiale Trennwände innen (Kompartimente)
    inner_radial_dividers(inner_r, inner_height);

    // 4) Radiale Trennwände außen (Kompartimente)
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
                cube([ r_in - max(inner_hub_radius, 0), inner_wall_thickness, h - bottom_thickness ]);
    }
}

// --- Außen: radiale Trennwände im Ring ---
module outer_radial_dividers(r_in, ring_w, h) {
    for (i = [0:outer_compartments-1]) {
        angle = 360/outer_compartments * i;
        rotate([0,0,angle])
            translate([r_in, -outer_wall_thickness/2, bottom_thickness])
                cube([ ring_w, outer_wall_thickness, h - bottom_thickness ]);
    }
}

// --- Aufruf ---
pen_holder();
