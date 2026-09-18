depth = 80;
inner_width = 22;
wall_width = 1.6;
height = 50;
amount = 8;
floor_thickness = 1.6;
rounding = 20;

/* [Hidden] */
$fn = 64;

width = wall_width + (inner_width + wall_width) * amount;

cube([width, depth, floor_thickness]);

for(i = [0:amount]) {
    x = i * (inner_width + wall_width);
    translate([x, 0, 0]) {
        wall();
    }
}

module wall() {
    // Center full-height wall piece.
    translate([0, rounding, 0]) {
        cube([wall_width, depth - rounding * 2, height]);
    }
    // Bottom full-depth wall piece.
    cube([wall_width, depth, height - rounding]);
    // Front rounding.
    translate([0, rounding, height - rounding]) {
        rotate([0, 90, 0]) {
            cylinder(h = wall_width, r = rounding);
        }
    }
    // Rear rounding.
    translate([0, depth - rounding, height - rounding]) {
        rotate([0, 90, 0]) {
            cylinder(h = wall_width, r = rounding);
        }
    }
}
