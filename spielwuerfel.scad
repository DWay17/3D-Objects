 // Spielwürfel D P T PD DT PT
size = 16;
r = 2;
text_depth = 0.8;
font_size = 6;

module face(txt) {
    linear_extrude(height = text_depth)
        text(txt, size = font_size, font = "Arial:style=Bold", halign="center", valign="center");
}

module die() {
    difference() {
        minkowski() {
            cube([size-2*r, size-2*r, size-2*r], center=true);
            sphere(r);
        }

        // Gravuren auf allen Seiten
        for (side = [
            ["D", [0, 0, size/2], [0,0,0]],
            ["P", [0, 0, -size/2], [180,0,0]],
            ["T", [0, size/2, 0], [-90,0,0]],
            ["PD", [0, -size/2, 0], [90,0,0]],
            ["DT", [size/2, 0, 0], [0,90,0]],
            ["PT", [-size/2, 0, 0], [0,-90,0]]
        ]) {
            translate(side[1])
                rotate(side[2])
                    translate([0,0,-text_depth])
                        face(side[0]);
        }
    }
}

die();
