inner_width = 80; // .1
inner_height = 20; // .1
inner_depth = 40; // .1

wall_thickness = 2; // .1
bottom_thickness = 2; // .1

hooks_count = 2;

/* [Hidden] */

$fn = 16;

// Preset dimensions.
hook_width = 4.5;
hole_distance = 40;
tiny = 0.001;

// Calculated outer dimensions.
container_width = inner_width + wall_thickness * 2;
container_height = inner_height + bottom_thickness;
container_depth = inner_depth + wall_thickness + hook_width;

hooks_width = hooks_count * hook_width + (hooks_count - 1) * (hole_distance - hook_width);

// Used to debug hook positioning.
fill_in = false;

// Render.
difference() {
    box();
    
    translate([container_width / 2 - hooks_width / 2, 0, container_height]) {
        for (i = [0:hooks_count - 1]) {
            translate([i * hole_distance, 0, 0]) {
                hook();
            }
        }
    }
}

module hook() {
    bottom_to_top = 15.5;
    top_cutout = 10;

    translate([0, 0, -hook_width]) {
        if (fill_in) {
            // Fill in above top cutout.
            # cube(hook_width);
        }
        
        // Top cutout.
        translate([0, 0, -top_cutout]) {
            translate([0, -tiny, 0]) {
                cube([hook_width, hook_width + tiny * 2, top_cutout]);
            }
            
            translate([0, 0, -bottom_to_top]) {
                if (fill_in) {
                    // Fill in between bottom and top cutout.
                    # cube([hook_width, hook_width, bottom_to_top]);
                }
                
                // Bottom cutout.
                translate([0, -tiny, -hook_width * 2]) {
                    cube([hook_width, hook_width + tiny * 2, hook_width * 2]);
                }
            }
        }
    }
}

module box() {
    module frontLeft() {
        translate([wall_thickness / 2, container_depth - wall_thickness / 2, 0]) {
            cylinder(h=container_height, d=wall_thickness);
        }
    }
    
    module frontRight() {
        translate([container_width - wall_thickness / 2, container_depth - wall_thickness / 2, 0]) {
            cylinder(h=container_height, d=wall_thickness);
        }
    }
    
    // Back (hooks side).
    cube([container_width, hook_width, container_height]);
    
    // Front.
    hull() {
        translate([wall_thickness, container_depth - wall_thickness, 0]) {
            cube([inner_width, wall_thickness, container_height]);
        }
        frontLeft();
        frontRight();
    }
    
    // Left.
    hull() {
        cube([wall_thickness, inner_depth + hook_width, container_height]);
        frontLeft();
    }
    
    // Right.
    hull() {
        translate([container_width - wall_thickness, 0, 0]) {
            cube([wall_thickness, inner_depth + hook_width, container_height]);
        }
        frontRight();
    }
    
    // Bottom.
    translate([wall_thickness / 2, 0, 0]) {
        cube([container_width - wall_thickness, container_depth - wall_thickness / 2, bottom_thickness]);
    }
}
