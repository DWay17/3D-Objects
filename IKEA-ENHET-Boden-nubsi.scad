

$fn = $preview ? 16 : 64;

pl_x = 11.0;
pl_y = 12.5;
pl_z = 1.7;

cy_d = 9.8;
cy_h = 8.8;
cy_hat_h = 2.0;
cy_hat_d1 = cy_d;
cy_hat_d2 = 7;

st_d = 3.05;
st_l = 7.9;
st_h = 6.5;
st_winkel = 5;

cut = pl_z + cy_h + cy_hat_h + 3;

%difference() {
    union() {
        cylinder(h=cy_h, r=cy_d/2);
        
        translate([0, 0, cy_h])
        cylinder(h=cy_hat_h, r1=cy_hat_d1/2, r2=cy_hat_d2/2, true);
        
        translate([ -(pl_x - cy_d)/2 , 0, -pl_z/2])
        cube([pl_x, pl_y, pl_z], true);
        
    }
    translate([cut/6 + cy_d/2 - 0.5, 0, cut/2 - pl_z - 1])
    cube([cut /3, pl_y, cut], true);
}
translate([cy_d - st_d/4 -1 , 0, st_h])
rotate([0, 90 - st_winkel, 0]) 
cylinder(h=st_l, r=st_d/2, center=true);

