//

innen_x = 60;
innen_y = 1.5;
innen_z = 120;
wand = 2;
aussen_x = innen_x + wand;
aussen_y = innen_y + wand;
aussen_z = innen_z + wand;
cylinder_1_d = innen_x * 0.50;
cylinder_2_d = innen_x * 0.35;

module cover () {
    difference() {
        // Außengehäuse
        cube([aussen_x, aussen_y, aussen_z], center=true);
        
        // Innengehäuse
        translate([0, 0, wand])
        cube([innen_x, innen_y, innen_z], center=true);
        translate([0, -aussen_y/2 + wand, 0])
        aussparung2();
    }
}

module aussparung2(){
    c_y = innen_z/4;
    rotate([90, 0, 0])
    linear_extrude(height=wand*1.05)
    union() {
        translate([0, c_y, 0])
        circle(d=cylinder_1_d);
        translate([0, -c_y, 0])
        circle(d=cylinder_2_d);
        polygon(points=[
            [cylinder_1_d/2, c_y],
            [cylinder_2_d/2, -c_y],
            [-cylinder_2_d/2, -c_y],
            [-cylinder_1_d/2, c_y]
        ]);
    };
}
//minkowski() {
union() {
translate([0, aussen_y/2 + 0*wand/2, 0])
rotate([0, 0, 180])
cover();

translate([0, 0, wand/2])
cube([aussen_x, wand, aussen_z + wand], center=true);

translate([0, -aussen_y/2 - 0*wand/2, 0])
rotate([0, 0, 0])
cover();
};
//cylinder(r=0.66, h=0.2);
//}