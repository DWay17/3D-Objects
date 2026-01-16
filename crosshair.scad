
dia = 2.5;
r1 = 250;
r2 = 125;
lin = 2*r1 + 2*dia;

linear_extrude  (height=2)
difference() 
{   
    outer();
    circle(r=dia);
}

module outer() 
    {
        difference() {
            circle(r=r1);
            circle(r=r1 - dia);
        }
        difference() {
            circle(r=r2);
            circle(r=r2 - dia);
        }
        square([dia, lin], center=true);
        square([lin, dia], center=true);
        circle(r= 2*dia);
    };
