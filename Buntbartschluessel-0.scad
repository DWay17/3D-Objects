//

 $fn = 64; // 64;
//$fa = 1;
//$fs = 0.5;

module schluessel(){
    // bart
    schaft_e_rad = 0.75;
    schaft_hoehe = 60 - schaft_e_rad * 2;
    schaft_durch = 7.0;
    schaft_rad = (schaft_durch / 2) - schaft_e_rad;
    bart_ecke_rad = 0.25;
    bart_x = 4.7               - bart_ecke_rad * 2; // 4.8
    bart_y = 20.5 - schaft_rad - bart_ecke_rad * 2 - 1;
    bart_z = 9.5                - bart_ecke_rad * 2;
    bart_tr_x = bart_ecke_rad;
    bart_tr_y = bart_ecke_rad;
    bart_tr_z = bart_ecke_rad;
    schaft_y = bart_y;
    schaft_tr_x = bart_x/2 + bart_ecke_rad;
    schaft_tr_y = schaft_y + bart_ecke_rad - schaft_e_rad;
    schaft_tr_z = -5.2 + schaft_e_rad;
    bart_schaft_eink_rad = 0.275 * (bart_x + bart_ecke_rad * 2);
    bart_schaft_eink_y = bart_y - schaft_rad - 0.9 + bart_ecke_rad * 2 -schaft_e_rad;
    bart_schaft_eink_l_x = -0.1 + 0 + 0 * bart_ecke_rad;
    bart_schaft_eink_r_x = +0.1 + bart_x + 2 * bart_ecke_rad;
    hoehe_e_s = bart_z + 2 * bart_ecke_rad;
    griff_tr_x = schaft_rad - schaft_e_rad * 2; 
    griff_tr_y = schaft_y + bart_ecke_rad - schaft_e_rad ;
    griff_tr_z = schaft_hoehe + schaft_e_rad;
    griff_e_rad = 1.25;
    griff_a = schaft_durch/2 - 1 * griff_e_rad;
    griff_b = 10 - 1 * griff_e_rad;
    griff_c = 11 - 1 * griff_e_rad;
    // bart
    // /*
    difference()
    {
        translate([bart_tr_x, bart_tr_y, bart_tr_z])
        minkowski() {
            cube([bart_x, bart_y, bart_z]);
            sphere(bart_ecke_rad);
        }
        // einkerbung
        translate([bart_schaft_eink_l_x, bart_schaft_eink_y, 0])
        cylinder(h=hoehe_e_s, r = bart_schaft_eink_rad);
        translate([bart_schaft_eink_r_x, bart_schaft_eink_y, 0])
        cylinder(h=hoehe_e_s, r = bart_schaft_eink_rad);
        
        // schweifung
        translate([5, 4.5, 0])
        cylinder(h=hoehe_e_s, r = 0.5   * (bart_x + 2 * bart_ecke_rad));
        
       // translate([2.7, - 0.25, 0])
        //cylinder(h=hoehe_e_s, r = 0.3   * (bart_x + 2 * bart_ecke_rad));
    }
    // */
    // schaft
    // /*
    translate([schaft_tr_x, schaft_tr_y, schaft_tr_z])
    minkowski() {
        cylinder(h = schaft_hoehe, r = schaft_rad);
        sphere(schaft_e_rad);
    }
    // */
    // /*
    // griff
    g_di = 3.5;
    minkowski() {
        translate([griff_tr_x, griff_tr_y, griff_tr_z])
        rotate([90, 0, 90])
            linear_extrude(height = g_di - griff_e_rad) 
            polygon(points=[
                [-griff_a/2, -griff_b],
                [ griff_a/2, -griff_b], 
                [ griff_c,  griff_b], 
                [-griff_c,  griff_b]
            ]
            )
        ;
        sphere(griff_e_rad);
    }
      
    // */ 
}
//translate([1,2,3])
schluessel(
    
);


