// Parametrischer Stiftköcher (OpenSCAD)
// Version 1.0

// --- Konfiguration ---
inner_diameter = 80;     // Innendurchmesser (mm)
height         = 110;    // Höhe (mm)
wall_thickness = 3;      // Wandstärke (mm)
bottom_thickness = 3;    // Bodenstärke (mm)

// Innenstruktur: "none", "radial", "grid"
insert_type    = "radial";

// Radiale Einsätze
compartments   = 6;      // Anzahl Fächer (z.B. 3–12)
insert_thickness = 2;    // Dicke der Trennwände (mm)

// Grid-Einsätze (Waben/Gitter)
cell_size      = 18;     // Zellenweite (mm)
cell_thickness = 2;      // Stegdicke (mm)

// Fillet oben (kleine Fase)
top_chamfer    = 1.2;    // 0 für keine Fase

$fn = 16; // Rundungen fein 128

// --- Hauptmodell ---
module pen_holder() {
    // Außenkörper
    difference() {
        // Mantel + Boden
        union() {
            // Mantel
            cylinder(h = height, r = (inner_diameter/2) + wall_thickness);

            // Boden
            translate([0,0,0])
                cylinder(h = bottom_thickness,
                         r = (inner_diameter/2) + wall_thickness);

            // Optional: kleine Fase oben
            if (top_chamfer > 0) {
                translate([0,0,height-top_chamfer])
                    cylinder(h = top_chamfer,
                             r1 = (inner_diameter/2) + wall_thickness,
                             r2 = (inner_diameter/2) + wall_thickness - top_chamfer);
            }
        }

        // Innenaushöhlung
        translate([0,0,bottom_thickness])
            cylinder(h = height - bottom_thickness,
                     r = inner_diameter/2);
    }

    // Innenstruktur einsetzen
    if (insert_type == "radial") {
        radial_insert();
    } else if (insert_type == "grid") {
        grid_insert();
    }
}

// --- Radiale Fächer ---
module radial_insert() {
    // Zentrale Nabe, damit Trennwände stabil sind
    hub_radius = min(6, inner_diameter/6);

    union() {
        // Nabe
        translate([0,0,bottom_thickness])
            cylinder(h = height - bottom_thickness,
                     r = hub_radius);

        // Trennwände
        for (i = [0:compartments-1]) {
            angle = 360/compartments * i;
            rotate([0,0,angle])
                translate([hub_radius, -insert_thickness/2, bottom_thickness])
                    cube([ (inner_diameter/2) - hub_radius,
                           insert_thickness,
                           height - bottom_thickness ]);
        }
    }
}

// --- Gittereinsatz (quadratisches Raster) ---
module grid_insert() {
    usable_radius = inner_diameter/2 - 0.6; // kleiner Spielraum
    usable_d = usable_radius*2;

    translate([0,0,bottom_thickness])
    linear_extrude(height = height - bottom_thickness)
    difference() {
        // Kreisbegrenzung für das Gitter
        circle(r = usable_radius);

        // Wir schneiden negative Flächen NICHT, stattdessen bauen wir das Gitter positiv:
        // Trick: Wir machen die Kreisfläche und subtrahieren große leere Flächen,
        // dann addieren die Stege separat unten.
    }

    // Gitterstege als positives Volumen
    union() {
        // Vertikale Stege
        for (x = [-floor(usable_d/cell_size):floor(usable_d/cell_size)]) {
            xpos = x * cell_size;
            if (abs(xpos) <= usable_radius) {
                translate([xpos,0,bottom_thickness])
                    linear_extrude(height = height - bottom_thickness)
                        offset(r = cell_thickness/2)
                            square([0.001, usable_d], center = true);
            }
        }
        // Horizontale Stege
        for (y = [-floor(usable_d/cell_size):floor(usable_d/cell_size)]) {
            ypos = y * cell_size;
            if (abs(ypos) <= usable_radius) {
                translate([0,ypos,bottom_thickness])
                    linear_extrude(height = height - bottom_thickness)
                        offset(r = cell_thickness/2)
                            square([usable_d, 0.001], center = true);
            }
        }
        // Begrenzungsring innen für saubere Kante
        translate([0,0,bottom_thickness])
            linear_extrude(height = height - bottom_thickness)
                difference() {
                    circle(r = usable_radius);
                    circle(r = usable_radius - cell_thickness);
                }
    }
}

// --- Aufruf ---
pen_holder();
