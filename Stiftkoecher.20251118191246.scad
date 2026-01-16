// Stiftköcher mit innerem Kern + schmalem Außenring (mit echten Fächern)
// Version 2.1

// --- Parameter ---
inner_diameter      = 60;   // Durchmesser des inneren Hauptfachs (mm)
inner_height        = 90;   // Höhe des inneren Fachs (mm)

outer_ring_width    = 20;   // Breite des äußeren Ringes (mm)
outer_height        = 60;   // Höhe des äußeren Ringes (mm)

wall_thickness      = 3;    // Außenwandstärke (mm)
bottom_thickness    = 3;    // Bodenstärke (mm)

outer_compartments  = 3;   // Anzahl der schmalen Außenfächer
outer_wall_thickness= 2;    // Dicke der Zwischenwände (mm) — wird in Winkel umgerechnet

$fn = 32; // Glätte für Rundungen

// --- Hilfsfunktion: Grad/Rad ---
function rad2deg(a) = a * 180 / PI;

// --- Modul: Ringschneide-Sektor (für Hohlräume der Außenfächer) ---
module ring_sector(r_in, r_out, angle_deg, h) {
    // Rechteck: (radiale Dicke x Höhe) wird um Z rotiert -> Torus-Segment
    rotate([0,0,-angle_deg/2])  // Zentriere den Sektor um 0°
    rotate_extrude(angle = angle_deg, convexity = 10)
        translate([r_in, 0, 0])
            square([r_out - r_in, h], center = false);
}

// --- Hauptmodul ---
module pen_holder() {
    inner_r = inner_diameter/2;
    outer_shell_r = inner_r + wall_thickness + outer_ring_width + wall_thickness;

    // 1) Außenkörper (Mantel + Boden)
    difference() {
        // Vollkörper außen
        union() {
            cylinder(h = max(inner_height, outer_height), r = outer_shell_r);
            // Optional: leichte Fase oben
            // translate([0,0,max(inner_height,outer_height)-1])
            //     cylinder(h=1, r1=outer_shell_r, r2=outer_shell_r-1);
        }

        // Innenaushöhlung: großes Innenfach
        translate([0,0,bottom_thickness])
            cylinder(h = inner_height - bottom_thickness, r = inner_r);

        // Außenring freistellen (zwischen innerer Wand und äußeren Wand)
        translate([0,0,bottom_thickness])
            cylinder(h = outer_height - bottom_thickness, r = inner_r + wall_thickness);

        // 2) Fächer im Außenring als ausgesparte Sektoren
        // Winkelberechnung: Wanddicke in Winkel am mittleren Ringradius
        ring_r_in   = inner_r + wall_thickness;
        ring_r_out  = ring_r_in + outer_ring_width;
        ring_mid_r  = (ring_r_in + ring_r_out) / 2;

        wall_angle_deg = rad2deg(outer_wall_thickness / ring_mid_r); // Bogen -> Winkel
        base_angle_deg = 360 / outer_compartments;
        slot_angle_deg = max(1, base_angle_deg - wall_angle_deg);     // Öffnungswinkel pro Fach

        // Aussparungen für alle Außenfächer
        for (i = [0:outer_compartments-1]) {
            angle_center = i * base_angle_deg;
            // Sektor anheben, damit Boden stehen bleibt
            translate([0,0,bottom_thickness])
                rotate([0,0,angle_center])
                    ring_sector(ring_r_in, ring_r_out, slot_angle_deg, outer_height - bottom_thickness);
        }
    }
}

// --- Aufruf ---
pen_holder();
