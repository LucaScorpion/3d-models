inner_diameter = 22.4;
thickness = 3;
height = 90;
edge_size = 5;

$fn = 64;

outer_diameter = inner_diameter + thickness * 2;

difference() {
    cylinder(h = height, r = outer_diameter / 2);
    translate([0, 0, -0.01]) {
        cylinder(h = height + 0.02, r = inner_diameter / 2);
    }
}

rotate_extrude() {
    triangle(edge_size - 0.01, outer_diameter / 2);
}

translate([0, 0, height]) {
    mirror([0, 0, 1]) {
        rotate_extrude() {
            triangle(edge_size - 0.01, outer_diameter / 2);
        }
    }
}

module triangle(size, offset) {
    polygon(
        [
            [offset, 0],
            [offset + size, 0],
            [offset, size]
        ]
    );
}
