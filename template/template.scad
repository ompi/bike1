r_outer = 316;
r_inner = r_outer - 29.2;
r_rim = r_outer - 12;

spoke_d = 4;
rim_width = 21;

led_pitch = 1000 / 30;
led_width = 10;
led_length = 54;
led_count = 56;

half_angle = 360 / 56 / 2;

r_led = led_pitch / 2 / sin(half_angle);

echo(r_led);

module led() {
    color("white")
    translate([-2.5, -2.5, 0])
    cube([5, 5, 1.4]);
}

module led_strip() {
    color("black")
    translate([-led_width / 2, -led_length / 2, 0])
    cube([led_width, led_length, 1]);
    
    translate([0, led_pitch / 2, 1])
    led();
    
    translate([0, -led_pitch / 2, 1])
    led();
}

for (a = [0 : 360/28 : 359])
    rotate([0, 0, a])
    translate([r_led, 0, 0])
    led_strip();

module rim() {
    $fn = 400;
    
    difference() {
        cylinder(r = r_outer, h = rim_width);
        
        translate([0, 0, -1])
        cylinder(r = r_inner, h = rim_width + 2);    
  
        translate([0, 0, rim_width - 1])  
        cylinder(r = r_rim, h = 2);    
    }

    module spoke() {
        l = 30;
        translate([r_inner - l, 0, rim_width / 2])
        rotate([0, 90, 0])
        cylinder(d = spoke_d, h = l);
    }

    for (a = [0 : 360/28 : 359])
        rotate([0, 0, a])
        translate([r_led, 0, 0])
        led_strip();
    
    for (a = [0 : 360/32 : 359])
        rotate([0, 0, a])
        spoke();
}

module template_() {
     
    module spoke() {
        $fn = 32;
        l = 30;
        translate([r_inner - l, 0, 0])
        rotate([0, 90, 0])
        cylinder(d = spoke_d, h = l);
        
        translate([r_inner - l, -spoke_d / 2, -spoke_d])
        cube([l, spoke_d, spoke_d]);
    }
    
    module led() {
        module marker() {
            translate([-7, -5/2, 0])
            cube([14, 5, 2]);
        }

        translate([0, led_pitch / 2, 1])
        marker();

        translate([0, -led_pitch / 2, 1])
        marker();
        
        translate([-led_width / 2, -led_length / 2, -3])
        cube([led_width, led_length, 10]);
    }
     
    meat = 2;
    extra_a = 2;
    p = 3;
    
    difference() {
        union() {
            translate([0, 0, -rim_width / 2 - spoke_d / 2])
            rotate([0, 0, -extra_a])
            rotate_extrude(angle = 45 + extra_a * 2, $fn = 400)
            translate([r_inner - meat, 0, 0])
            square([meat, meat + rim_width / 2 + spoke_d / 2]);

            translate([0, 0, 0])
            rotate([0, 0, -extra_a])
            rotate_extrude(angle = 45 + extra_a * 2, $fn = 400)
            translate([r_inner - meat, 0, 0])
            square([r_outer - r_inner + meat * 2, meat]);
            
            translate([0, 0, -p])
            rotate([0, 0, -extra_a])
            rotate_extrude(angle = 45 + extra_a * 2, $fn = 400)
            translate([r_outer, 0, 0])
            square([meat, meat + p]);
        }
        
        translate([0, 0, -rim_width / 2])
        for (a = [0 : 360/32 : 45])
            rotate([0, 0, a])
            spoke();
        
        for (a = [0 : 360/28 : 45])
            rotate([0, 0, a])
            translate([r_led, 0, 0])
            led();
    }
}

module template() {
    rotate([0, 0, -20])
    translate([r_rim, 0, 0]) 
    rotate([0, 180, 0])
    template_();
}

template_();

translate([0, 0, -rim_width])
rim();
