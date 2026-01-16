// Deko-Buntbartschlüssel (nicht funktional)
// Maße bewusst generisch und nicht kompatibel zu realen Schlössern

/* v0.1
$fn = 64;
// Gesamtlänge ~80 mm
module schluessel() {
    // Griff (rund)
    difference() {
        cylinder(h = 6, r = 15);
        cylinder(h = 6, r = 7);
    }x
    // Schaft
    translate([0,0,0])
        cylinder(h = 50, r = 3);
    // Gerader Bart (rein dekorativ)
    translate([-3, -1.5, 50])
        cube([6, 12, 3]);
}

schluessel();
*/
// Deko-Buntbartschlüssel (nicht funktional)
// Griff sitzt bündig oben am Schaft

$fn = 64;

module schluessel() {
    // Schaft
    schaft_hoehe = 70;
    bart_durch = 7.3;
    schaft_rad = bart_durch / 2;
    cylinder(h = schaft_hoehe, r = schaft_rad);

    // Griff (rund), direkt auf Schaft
    /*
    translate([-2.5, -7.5, schaft_hoehe])
    cube([5,15,25]);
*/
    g_di = 3.5;
    translate([-g_di/2, 0, schaft_hoehe])
        rotate([90, 0, 90])
            linear_extrude(height = g_di)
                polygon(points=[
                    [-bart_durch/2, -10],  // unten links (schmaler)
                    [ bart_durch/2, -10],  // unten rechts
                    [ 11,  10],  // oben rechts (breiter)
                    [-11,  10]   // oben links
                ])
    ;   
    bart_x = 5.5;
    // Gerader, dekorativer Bart
    translate([-bart_x/2, 0, 5])
        cube([bart_x, 20.5-schaft_rad, 10]);
    
}

//schluessel();
module schluessel2(){
    // bart
    bart_x = 5;
    bart_y = 20.5;
    bart_z = 10;
    difference()
    {
        cube([bart_x, bart_y, bart_z]);
        translate([5,5,0])
        cylinder(h=bart_z, r = 0.5*bart_x);
    }
    // schaft
    schaft_hoehe = 70;
    schaft_durch = 7.3;
    schaft_rad = schaft_durch / 2;
    schaft_y = bart_y;
    translate([bart_x/2,schaft_y,-5])
    cylinder(h = schaft_hoehe, r = schaft_rad);
    // griff
    g_di = 3.5;
    translate([bart_x/2-schaft_rad/2, schaft_y, schaft_hoehe])
        rotate([90, 0, 90])
            linear_extrude(height = g_di)
                polygon(points=[
                    [-schaft_durch/2, -10],
                    [ schaft_durch/2, -10], 
                    [ 11,  10], 
                    [-11,  10]
                ])
    ;   
}
schluessel2();


