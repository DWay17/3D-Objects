//

// $fn = 16; // 64;
$fa = 1;
$fs = 0.5;

module schluessel2(){
    // bart
    schaft_hoehe = 50;
    schaft_durch = 7.2;
    schaft_rad = schaft_durch / 2;
    bart_ecke_rad = 1;
    bart_x = 4.8               - bart_ecke_rad * 2;
    bart_y = 20.5 - schaft_rad - bart_ecke_rad * 2;
    bart_z = 10                - bart_ecke_rad * 2;
    bart_tr_x = bart_ecke_rad;
    bart_tr_y = bart_ecke_rad;
    bart_tr_z = bart_ecke_rad;
    schaft_y = bart_y;
    schaft_tr_x = bart_x/2 + bart_ecke_rad;
    schaft_tr_y = schaft_y + bart_ecke_rad;
    schaft_tr_z = -5;
    bart_schaft_eink_rad = 0.25 * bart_x;
    bart_schaft_eink_y = bart_y - schaft_rad - 0.4;
    bart_schaft_eink_l_x = 0;
    bart_schaft_eink_r_x = bart_x;
    bart_x/2-schaft_rad/2, 
    schaft_y, 
    schaft_hoehe
    
    difference()
    {
        translate([bart_tr_x, bart_tr_y, bart_tr_z])
        minkowski() {
            cube([bart_x, bart_y, bart_z]);
            sphere(bart_ecke_rad);
        }
        
        translate([bart_schaft_eink_l_x, bart_schaft_eink_y, 0])
        cylinder(h=bart_z, r = bart_schaft_eink_rad);
        translate([bart_schaft_eink_r_x, bart_schaft_eink_y, 0])
        cylinder(h=bart_z, r = bart_schaft_eink_rad);

        translate([5,5,0])
        cylinder(h=bart_z, r = 0.5   * bart_x);
    }
    // schaft
    translate([schaft_tr_x, schaft_tr_y, schaft_tr_z])
    cylinder(h = schaft_hoehe, r = schaft_rad);
    // griff
    g_di = 3.5;
    translate([])
        rotate([90, 0, 90])
    //minkowski() {
        linear_extrude(height = g_di) 
        polygon(points=[
            [-schaft_durch/2, -10],
            [ schaft_durch/2, -10], 
            [ 11,  10], 
            [-11,  10]
        ]
        )
            
        //sphere(2);
      //  }
    ;   
}
schluessel2();


