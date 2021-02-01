use <standoffs.scad>;

$fn = 128;
dxf = "weather-station.dxf";
standoff = 3;
grill = 1.5;
grill_hole = 1;
grill_size = 15;
grill_slant = 0.8;
extend = 4;
squish = 0.125;
feet_offset = 0;
mid_x = 36.225;

enable_bottom = 0;
enable_board = 0;
enable_grill = 1;
enable_feet = 1;
enable_lid = 1;
enable_flat = 1;
enable_lock = 1;
enable_standoffs = 0;
enable_explode = 0;
enable_heat = 0;
enable_cover = 0;
enable_align = 0;

module align() {
    linear_extrude(height = 15) 
    import(dxf, layer = "LCD_ALIGN");
}

module gpio() {
    translate([mid_x + 5, 110, 29])
    rotate([90, 0, 0])
    hull() {
        translate([-28, 0, 0])
        cylinder(r = 3, h = 20);
        translate([28, 0, 0])
        cylinder(r = 3, h = 20);
    }
}

module grilled(count = 10, deep = -10) {
    if (enable_grill > 0) {
        for (x = [0: count]) {
            hull() {
                translate([0, x * grill * 4, deep])
                sphere(grill_hole, $fn = 24);
                translate([13, x * grill * 4, deep])
                sphere(grill_hole, $fn = 24);
                translate([0, x * grill * 4 - grill_size / 2  - extend / 2, (grill_size  + extend) * grill_slant])
                sphere(grill_hole, $fn = 24);
                translate([13, x * grill * 4 - grill_size / 2 - extend / 2, (grill_size + extend) * grill_slant])
                sphere(grill_hole, $fn = 24);
            }
        }
    }
}

module feet() {
    if (enable_feet > 0) {
        translate([-24.85, 16.5, -0.5])
        color([0, 0.75, 0.5])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
        translate([-24.85, 88.5, -0.5])
        color([0, 0.75, 0.5])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
        translate([97.3, 88.5, -0.5])
        color([0, 0.75, 0.5])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
        translate([97.3, 16.5, -0.5])
        color([0, 0.75, 0.5])
        scale([1, 1, squish])
        sphere(4.5, $fn = 32);
        if (enable_lock == 0) {
            scale([1, 1, -1])
            translate([-24.85, 16.5, 0])
            countersink(10);
            scale([1, 1, -1])
            translate([-24.85, 88.5, 0])
            countersink(10);
            scale([1, 1, -1])
            translate([97.3, 88.5, 0])
            countersink(10);
        }
    }
}

module bottom() {
    difference() { 
        union () {
            translate([0, 0, 0.5])
            hull() {
                linear_extrude(height = 1) 
                import(dxf, layer = "BOTTOM");
                translate([0, 0, -1])
                linear_extrude(height = 1) 
                import(dxf, layer = "BOTTOM_BEVEL");
                
            }
            if (enable_lock == 0) {
                translate([-24.85, 16.5, 0])
                sleeve(3.5, 5);
                translate([-24.85, 88.5, 0])
                sleeve(3.5, 5);
                translate([97.3, 88.5, 0])
                sleeve(3.5, 5);
            }
            translate([0, 0, 1.5])
            linear_extrude(height = 27.5)
            import(dxf, layer = "WALL");
            if (enable_lock > 0) {
                translate([0, 0, 1])
                linear_extrude(height = 28)
                import(dxf, layer = "LOCK_SLOT");
            }
        }
        if (enable_lock > 0) {
            translate([0, 0, -2])
            linear_extrude(height = 5)
            import(dxf, layer = "LOCK_RELEASE");
            rotate([0, 90, 0])
            translate([-6, 93, -11.05])
            cylinder(r = 2.5, h = 4);
            rotate([0, 90, 0])
            translate([-6, 93, 79.6])
            cylinder(r = 2.5, h = 4);
        }
        if (enable_standoffs > 0) {
            translate([20.5, 13.5, 1.6])
            standoffDrill(1);
            translate([20.5, 62.5, 1.6])
            standoffDrill(1);
            translate([78.5, 13.5, 1.6])
            standoffDrill(1);
            translate([78.5, 62.5, 1.6])
            standoffDrill(1);
        }
        gpio();
        feet();
        translate([0, 0, 1])
        linear_extrude(height = 26.5)
        import(dxf, layer = "HEAT_GROOVE");
        translate([-43, 27, 5])
        grilled(10);
        translate([9, 104.5, 5])
        rotate([0, 0, -90])
        grilled(11);
        translate([0, 0, 1.5]) {
            translate([0, 10, 12.5 + standoff])
            rotate([90, 0, 0])
            linear_extrude(height = 4)
               import(dxf, layer = "FRONT", $fn = 32);
            translate([90, 0, 136.5 + standoff])
            rotate([0, 90, 0])
            linear_extrude(height = 20)
               import(dxf, layer = "SIDE");
        }
    }
    difference() {
        translate([0, 0, 1.5]) {
            if (enable_standoffs > 0) {
                translate([20.5, 13.5, 0])
                standoff(3.5, 1.5);
                translate([78.5, 13.5, 0])
                standoff(3.5, 1.5);
                translate([78.5, 62.5, 0])
                standoff(3.5, 1.5);
                translate([20.5, 62.5, 0])
                standoff(3.5, 1.5);
            }
            if (enable_board > 0) {
                translate([0, 0, standoff + 0.5])
                color([0, 0.4, 0])
                linear_extrude(height = 1.63)
                   import(dxf, layer = "BOARD_OUTLINE");
            }
        }
    }
    translate([0, 0, 1.5])
    linear_extrude(height = 25.2 + extend - 1.7)
       import(dxf, layer = "HEAT_TABS");
    
}

module heat() {
    slide = 10;
    difference() {
        translate([0, 0, -0.25])
        linear_extrude(height = 26.2 + extend)
        import(dxf, layer = "HEAT");
        translate([-20, 23, 0])
        rotate([0, 90, 0])
        cylinder(r = 2.75, h = 10);
    }
    translate([-17.20, 68 + slide, (26.75 + extend) / 2])
    rotate([90, 0, 90])
    scale([1, 1, -1])
    standoffNoTaper(3.5, 1.5);
    translate([-17.20, 40 + slide, (26.75 + extend) / 2])
    rotate([90, 0, 90])
    scale([1, 1, -1])
    standoffNoTaper(2.5, 0.5);
}

module lid() {
    if (enable_flat == 0) {
        difference() {
            intersection() {
                linear_extrude(height = 5) 
                import(dxf, layer = "LID");
                translate([0, 115, 12])
                rotate([90, 0, 0])
                linear_extrude(height = 120) 
                import(dxf, layer = "LID_FRONT", $fn = 3600);
            }
            translate([0, 0, -2])
            linear_extrude(height = 10) 
            import(dxf, layer = "LCD");
        }
        difference() {
            intersection() {
                linear_extrude(height = 5) 
                import(dxf, layer = "LID_RAISE", $fn = 48);
                translate([0, 115, 13])
                rotate([90, 0, 0])
                linear_extrude(height = 120) 
                import(dxf, layer = "LID_FRONT", $fn = 3600);
            }
        }
    }
    if (enable_flat > 0) {
        linear_extrude(height = 3) 
        import(dxf, layer = "LID_RAISE", $fn = 48);
        difference() {
            linear_extrude(height = 2) 
            import(dxf, layer = "LID");
            translate([0, 0, -2])
            linear_extrude(height = 10) 
            import(dxf, layer = "LCD");
        }
    }
}

module cover() {
    scale([1, 1, -1]) {
        difference() {
            linear_extrude(height = 1) 
            import(dxf, layer = "BOTTOM");
            translate([0, 0, -1])
            linear_extrude(height = 3) 
            import(dxf, layer = "LCD");
            translate([-10.275, 25, 1])
            standoffDrill(2);
            translate([-10.275, 80, 1])
            standoffDrill(2);
            translate([82.725, 80, 1])
            standoffDrill(2);
            translate([82.725, 25, 1])
            standoffDrill(2);
        }
        linear_extrude(height = 4) 
        import(dxf, layer = "COVER");
        linear_extrude(height = 8) 
        import(dxf, layer = "COVER_EDGE");
        translate([-10.275, 25, 0])
        standoffNoTaper(3.5, 1.5);
        translate([-10.275, 80, 0])
        standoffNoTaper(3.5, 1.5);
        translate([82.725, 80, 0])
        standoffNoTaper(3.5, 1.5);
        translate([82.725, 25, 0])
        standoffNoTaper(3.5, 1.5);
        if (enable_lock == 0) {
            translate([-24.85, 16.5, 1])
            standoffPost(30, 3.4);
            translate([-24.85, 88.5, 1])
            standoffPost(30.25, 3.4);
            translate([97.3, 88.5, 1])
            standoffPost(30.25, 3.4);
            translate([97.3, 88.5, 1])
            standoffPost(27.4, 3.4);
        }
        if (enable_lock > 0) {
            linear_extrude(height = 31.25)
            import(dxf, layer = "LOCK_RAIL");
            linear_extrude(height = 35)
            import(dxf, layer = "LOCK_PULL");
            hull() {
                linear_extrude(height = 1)
                import(dxf, layer = "LOCK_B1");
                linear_extrude(height = 7)
                import(dxf, layer = "LOCK_B2");
            }
            hull() {
                linear_extrude(height = 1)
                import(dxf, layer = "LOCK_B3");
                linear_extrude(height = 7)
                import(dxf, layer = "LOCK_B4");
            }
            rotate([0, 90, 0])
            translate([-27, 93, -10.90]) 
            cylinder(r = 2.7, h = 3.7);
            rotate([0, 90, 0])
            translate([-27, 93, 79.65])
            cylinder(r = 2.7, h = 3.7);
        }
    }
}

if (enable_bottom > 0)
    bottom();

if (enable_heat > 0) {
    if (enable_explode > 0)
        translate([0, 0, 33.5])
        heat();
    if (enable_explode == 0)
        translate([140, -10, 19.35])
        rotate([90, 90, 0])
        heat();
}

if (enable_lid > 0) {
    if (enable_explode > 0)
        translate([0, 0, 80])
        lid();
    if (enable_explode == 0)
        lid();
    
}

if (enable_cover > 0) {
    if (enable_explode > 0) 
        translate([0, 0, 80])
        cover();
    if (enable_explode == 0)
        translate([20, 0, 3])
        rotate([180, 0, 0])
        cover();
}

if (enable_align > 0) {
    align();
}
