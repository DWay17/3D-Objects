
$fn = $preview ? 16 : 64;

b_b = 365;
b_h = 18;
b_t = 128;

hole_h = 10;
hole_d = 10;
hole_t1 = 5;
hole_t2 = 22.5;
hole_b = 0.83;
hole_h2 = 0.1;

prototype = true;
pt_b = 10;

cutoff_b = b_b/2 - 3.5 * pt_b;
cutoff_t = b_t - 2 * pt_b;

ausp = 10;
ausp_b = 12.5;

hex_radius = 7;      // Abstand von Mitte zur Ecke
wand_staerke = 3;    // Abstand zwischen den Löchern

brett_breite = b_b - 3.5 * pt_b;
brett_tiefe  = b_t - 1 * pt_b;
brett_hoehe  = b_h/2;

// --- Berechnung ---
// Abstand zwischen den Mittelpunkten der Hexagone
x_step = (hex_radius * cos(30)) * 2 + wand_staerke;
y_step = (hex_radius * 1.5) + (wand_staerke * cos(30));
x_offset = 0;
y_offset = 0;

%difference() {
    cube([b_b, b_t, b_h], center=true);

    translate([b_b/2 - hole_d/2 + hole_b, b_t/2 - hole_d/2 - hole_t1, -b_h/2 - hole_h2])
    cylinder(h=hole_h, d=hole_d);
    
    translate([b_b/2 - hole_d/2 + hole_b, -b_t/2 + hole_d/2 + hole_t2, -b_h/2 - hole_h2])
    cylinder(h=hole_h, d=hole_d);

    translate([-b_b/2 + hole_d/2 - hole_b, b_t/2 - hole_d/2 - hole_t1, -b_h/2 - hole_h2])
    cylinder(h=hole_h, d=hole_d);
    
    translate([-b_b/2 + hole_d/2 - hole_b, -b_t/2 + hole_d/2 + hole_t2, -b_h/2 - hole_h2])
    cylinder(h=hole_h, d=hole_d);

    
    translate([-(b_b/2 - 2.3 * pt_b)/2 - pt_b, 0, 0])
    cube([cutoff_b, cutoff_t, b_h + 0.1], true);
    translate([+(b_b/2 - 2.3 * pt_b)/2 + pt_b, 0, 0])
    cube([cutoff_b, cutoff_t, b_h + 0.1], true);
}

difference()
{
    {
        translate([0, 0, b_h/4])
        cube([b_b - pt_b, b_t - pt_b, b_h/2], true);
    }
    echo(str("b_h/2 = ", b_h/2));
    if (false)
    for (x=[-b_b/2 + ausp_b:ausp*2:+b_b/2-ausp_b]) {
        for (y=[-b_t/2 + ausp_b:ausp*2:+b_t/2-ausp_b]) {
                if (abs(x) > 15) {
                    echo(str("x = ", x));
                    echo(str("y = ", y));
                    translate([x, y, 0])
                    translate([0, 0, b_h/4 + 0.2])
                    rotate([0, 0, 45])
                    cube(size=[ausp, ausp, b_h/2 + 0.5], center=true);
                    //#cylinder(h=b_h/2 + 0.7, d=ausp, true);
                }
            }
        }
    echo(str("brett_hoehe + 2 = ", brett_hoehe + 2));
    //translate([hex_radius, hex_radius, -1]) 
    { // Kleiner Offset für sauberen Schnitt
        for (y = [-brett_tiefe/2 - y_offset: y_step : brett_tiefe/2 + y_offset]) {
            // Versatz für jede zweite Reihe (Waben-Effekt)
            offset_x = (floor(y / y_step) % 2 == 0) ? 0 : x_step / 2;
            
            for (x = [-brett_breite/2 - x_offset: x_step : brett_breite/2 + x_offset]) {
                if (abs(x + offset_x) > pt_b + 2) {
                    translate([x + offset_x, y, 0])
                    translate([0, 0, 0 - 1])
                        rotate([0, 0, 30]) // Spitze nach oben ausrichten
                        cylinder(h = brett_hoehe + 3, r = hex_radius, $fn = 6);
                }
            }
        }
    }
}

