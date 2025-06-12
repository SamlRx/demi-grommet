// === CUSTOMIZABLE PARAMETERS ===
outer_width = 100;     // Outer width of the half-oval (X-axis)
outer_height = 30;     // Outer height (Y-axis)
wall_thickness = 2;    // Wall thickness of the grommet
depth = 19;            // Total depth (Z-axis)
flange_height = 2;     // Height of the outer flange
flange_width = 10;     // Additional width of the outer flange
resolution = 100;      // Resolution for curves

module half_oval(w, h) {
    scale([w / 2, h])
        polygon(points = concat(
            [for (i = [0 : resolution]) [cos(i * 180 / resolution), sin(i * 180 / resolution)]],
            [[1, 0], [-1, 0]] // flat base
        ));
}

module grommet_body(w, h, d) {
    linear_extrude(height = d)
        half_oval(w, h);
}

module grommet_flange(w, h, offset) {
    translate([0, 0, offset])
        linear_extrude(height = flange_height)
            half_oval(w + flange_width, h + flange_width * (h / w));
}

module inner_cavity(w, h) {
    translate([0, 0, -flange_height])
        linear_extrude(height = depth + flange_height * 2)
            half_oval(w - 2 * wall_thickness, h - 2 * wall_thickness);
}


module screw_hole() {
    translate([0, outer_height - wall_thickness , depth / 2])  
        rotate([90, 0, 0])
            cylinder(h = outer_width, r1 = 1.5, r2 = 3, center = true, $fn = 50);
}


module half_grommet() {
    difference() {
        union() {
            grommet_body(outer_width, outer_height, depth);
            grommet_flange(outer_width, outer_height, depth); 
            grommet_flange(outer_width, outer_height, -flange_height);
        }
        inner_cavity(outer_width, outer_height);
        screw_hole();
    }
}

half_grommet();
