/* Ants drinking bowl */
b_h  = 7;
b_d1 = 35;
b_d2 = b_d1 - 2 * b_h - 1;

g_h = 35;
g_d = 3;

p_d = 6;
p_t_x = p_d/2 + g_d/2 + 2.5;

$fn = $preview ? 32 : 64;

difference() 
{
    // base
    cylinder(h=b_h, d1=b_d1, d2=b_d2);

    // pool
    translate([0, 0, b_h + 2.3])
    rotate_extrude()
    translate([p_t_x, 0, 0])
    circle(d = p_d );
}

// grip
cylinder(h=g_h, d=g_d);
translate([0, 0, g_h])
sphere(r=2);
