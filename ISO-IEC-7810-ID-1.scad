// essenskarte_paul

$fn = $preview ? 16 : 24;

l = 86.6;
b = 53.98;
h = 0.8;
mk = 3.18 * 2;
f = 1.01;

difference (){
    union () {
        minkowski () 
        {
            cube([l - mk, b - mk, h]);
            cylinder(h=h, d=mk);
        }
    }
}
