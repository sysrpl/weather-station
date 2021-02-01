enable_standoffTest = 1;

module standoff(height, offset = 0) {
    if (offset == 0) {
        difference() {
            cylinder(r1 = 3 * height / 5 + 6 / 2, r2 = 6 / 2, h = height, $fn = 32);
            translate([0, 0, -0.1])
            cylinder(r = 2.3 / 2, h = height + 0.2, $fn = 32);
            translate([0, 0, height - 1])
            cylinder(r1 = 2.3 / 2, r2 = 3.3 / 2, h = 1.1, $fn = 32);
        }
    }
    if (offset > 0) {
        difference() {
            union() {
                cylinder(r = 6 / 2, h = height, $fn = 32);
                cylinder(r1 = 3 * (height - offset) / 5 + 6 / 2, r2 = 5.5 / 2, h = height - offset, $fn = 32);
            }
            translate([0, 0, -0.1])
            cylinder(r = 2.3 / 2, h = height + 0.2, $fn = 32);
            translate([0, 0, height - 1])
            cylinder(r1 = 2.3 / 2, r2 = 3.3 / 2, h = 1.1, $fn = 32);
        }
    }
}

module standoffNoTaper(height, offset = 0) {
    if (offset == 0) {
        difference() {
            cylinder(r1 = 3 * height / 5 + 6 / 2, r2 = 6 / 2, h = height, $fn = 32);
            translate([0, 0, -0.1])
            cylinder(r = 2.3 / 2, h = height + 0.2, $fn = 32);
        }
    }
    if (offset > 0) {
        difference() {
            union() {
                cylinder(r = 6 / 2, h = height, $fn = 32);
                cylinder(r1 = 3 * (height - offset) / 5 + 6 / 2, r2 = 5.5 / 2, h = height - offset, $fn = 32);
            }
            translate([0, 0, -0.1])
            cylinder(r = 2.3 / 2, h = height + 0.2, $fn = 32);
        }
    }
}

module standoffPost(height, radius) {
    difference() {
        union() {
            cylinder(r = radius, h = height, $fn = 32);
            cylinder(r1 = radius + 2.5, r2 = radius, h = 2.5, $fn = 32);
        }
        translate([0, 0, height - 6])
        cylinder(r = 2.3 / 2, h = 6.1);
    }

}

module standoffDrill(depth) {
    translate([0, 0, -depth - 0.01])
    cylinder(r = 2.4 / 2, h = depth + 0.02, $fn = 32);
}

module countersink(depth) {
    translate([0, 0, -depth - 0.1])
    cylinder(r = 3 / 2, h = depth + 0.2, $fn = 32);
    translate([0, 0, -1.5])
    cylinder(r1 = 3 / 2, r2 = 5.5 / 2, h = 1.55, $fn = 32);
}

module sleeve(inner, height, wall = 2) {
    difference() {
        cylinder(r = inner + wall, h = height, $fn = 64);
        translate([0, 0, -0.1])
        cylinder(r = inner, h = height + 0.2, $fn = 64);
    }
}


module standoffTest() {
    difference() {
        translate([0, 0, -2])
        cube([40, 40, 2]);
        translate([10, 30, 0])
        standoffDrill(2);
        translate([30, 30, 0])
        standoffDrill(2);
        translate([20, 20, 0])
        countersink(2);
    }
    translate([10, 30, 0])
    standoff(5);
    translate([10, 10, 0])
    standoff(5);
    translate([30, 30, 0])
    standoff(5, 2.5);
    translate([30, 10, 0])
    standoff(3, 1.5);
    translate([20, 20, 0])
    sleeve(4, 3);
}

if (enable_standoffTest > 0)
    standoffTest();