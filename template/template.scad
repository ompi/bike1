r_outer = 316;
r_inner = r_outer - 29.2;
r_rim = r_outer - 12;

spoke_d = 4;
rim_width = 21;

led_pitch = 1000 / 30;
led_width = 10;
led_length = 66; //54;
led_count = 56;
strip = 62;

half_angle = 360 / 56 / 2;

r_led = led_pitch / 2 / sin(half_angle);

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

//translate([-330, 0, 0])
for (a = [0 : 360/28 : 359])
    rotate([0, 0, a])
    translate([r_led, 0, 10])
    led_strip();

module number(n) {
    num = [
        [
            [ 1, 1, 1 ],
            [ 1, 1, 1 ],
            [ 1, 1, 1 ],
            [ 1, 1, 1 ],
            [ 1, 1, 1 ],
        ],
    [
            [ 0, 1, 1 ],
            [ 0, 0, 1 ],
            [ 0, 0, 1 ],
            [ 0, 0, 1 ],
            [ 0, 0, 1 ],
        ],
        [
            [ 1, 1, 1 ],
            [ 0, 0, 1 ],
            [ 1, 1, 1 ],
            [ 1, 0, 0 ],
            [ 1, 1, 1 ],
        ],
        [
            [ 1, 1, 1 ],
            [ 0, 0, 1 ],
            [ 0, 1, 1 ],
            [ 0, 0, 1 ],
            [ 1, 1, 1 ],
        ],
        [
            [ 1, 0, 1 ],
            [ 1, 0, 1 ],
            [ 1, 1, 1 ],
            [ 0, 0, 1 ],
            [ 0, 0, 1 ],
        ],
        [
            [ 1, 1, 1 ],
            [ 1, 0, 0 ],
            [ 1, 1, 1 ],
            [ 0, 0, 1 ],
            [ 1, 1, 1 ],
        ],
        [
            [ 1, 1, 1 ],
            [ 1, 0, 0 ],
            [ 1, 1, 1 ],
            [ 1, 1, 1 ],
            [ 1, 1, 1 ],
        ],
        [
            [ 1, 1, 1 ],
            [ 1, 0, 1 ],
            [ 1, 0, 1 ],
            [ 0, 0, 1 ],
            [ 0, 0, 1 ],
        ],
    ];
    
    for (i = [0:5])
        for (j = [0:3])
             if (num[n][i][j])
                 translate([j, 4 - i, -1])
                 cube([1, 1, 2]);
             
     translate([4, 0, -1])
         cube([1, 1, 2]);
}

module rim() {
    w = 20.7;
    hole_d = 9;
    depth = 8 - 5.6;
    
    R = (pow(hole_d/2, 2) + pow(depth, 2)) / 2 / depth;
    
    h = 16.9;
    
    d0 = 18.4;
    d1 = 16.5;
    d2 = 13.8;
    d3 = 10.0;
    
    module rim_cross() {
        difference() {
            polygon([
                [w/2 + d0/2, 0],
                [w/2 + d1/2, -h * 0.25],
                [w/2 + d2/2, -h * 0.5],
                [w/2 + d3/2, -h * 0.75],
                [w/2, -h],
                [w/2 - d3/2, -h * 0.75],
                [w/2 - d2/2, -h * 0.5],
                [w/2 - d1/2, -h * 0.25],
                [w/2 - d0/2, 0],
                [0, 0],
                [0, 12.4],
                [3, 12.4],
                [3, 6.8],
                [17.7, 6.8],
                [17.7, 12.4],
                [20.7, 12.4],
                [20.7, 6.8],
                [20.7, 0],
            ]);

            translate([w / 2, 6.8 + R - depth, 0])
            circle(r = R, $fn = 32);
        }
    }
    
    difference() {
        translate([0, 0, w / 2])
        rotate_extrude(angle = 360, $fn = 200)
        translate([r_outer - 12.4, 0, 0])
        rotate([0, 0, -90])
        rim_cross();
        
        for(a = [0:360/32:359])
            rotate([0, 0, a + 360 / 64])
            translate([r_rim - 10, 0, 0])
            rotate([0, 90, 0])
            cylinder(d = hole_d, h = 40, $fn = 32);
    }
}

difference() {
    rim();
    
    *rotate([0, 0, -15])
    rotate_extrude(angle = 30, $fn = 200)
    translate([r_inner, 0, 0])
    square(r_outer - r_inner +   5, 20);
    
    translate([260, -200, -30])
    cube([60, 200, 60]);
}

module template_(n, m) {
    meat = 2;
    w = 20;
    h = 130;
    
    module key_half() {    
        difference() {
            translate([299, 0, -meat / 2])
            cube([w, h / 2, meat]);
            
            translate([0, 0, -meat])
            cylinder(r = 308.2, h = meat * 2, $fn = 400);

            translate([260, -200, -30])
            cube([60, 200, 60]);
        }
        
        translate([0, 0, -meat / 2])
        difference() {
            W = 8.6;
            rotate([0, 0, 360 / 64])
            translate([305, -W / 2, 0])
            cube([10, W, meat]);

            translate([300, 0, -meat / 2])
            cube([10, 25.95, meat * 2]);
        }
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
        
        translate([-led_width / 2, -strip / 2, -3])
        cube([led_width, strip, 10]);
    }
    
    rotate([0, 0, 360/32 * m]) {
        mirror([0, 1, 0])
        key_half();
        key_half();

        W2 = 20.7 / 2;

        difference() {
            translate([299, -h / 2, W2 - meat * 2 + 0.1])
            cube([w, h, meat * 2]);

            cylinder(r = 316.1, h = W2 + meat, $fn = 400);
        }
        
        difference() {
            translate([279, -h / 2, W2 + 0.1])
            cube([40, h, meat]);

            cylinder(r = 295, h = W2 + meat * 2, $fn = 400);

            rotate([0, 0, 360/28 * n - 360/32 * m])
            translate([r_led, 0, W2 + 0.1])
            led();
        }
        
        difference() {
            translate([317, -h / 2, 0])
            cube([2, h, 10]);
            
            translate([319, 0, 2])
            rotate([90, 0, 90])
            number(n);
        }
    }
}

/*
template_(0, 0);
template_(1, 1);
template_(2, 2);
template_(3, 3);
template_(4, 5);
template_(5, 6);
template_(6, 7);
*/

module template(n, m) {
    rotate([0, 90, 0])
    rotate([0, 0, -360/32 * m])
    template_(n, m);
}

module template0() {
    template(0, 0);
}

module template1() {
    template(1, 1);
}

module template2() {
    template(2, 2);
}

module template3() {
    template(3, 3);
}

module template4() {
    template(4, 5);
}

module template5() {
    template(5, 6);
}

module template6() {
    template(6, 7);
}

template0();
template1();
template2();
template3();
template4();
template5();
template6();

module cut() {
    w = 10.1;
    meat = 2;    
    t = 0.5;
    h = 6;
    extra = 10;
    strip = 62;

    module led() {
        module marker() {
            translate([-(w + 2) / 2, -5/2, 0])
            cube([w + 2, 5, 5]);
        }

        translate([w/2, led_pitch / 2, meat])
        marker();

        translate([w/2, -led_pitch / 2, meat])
        marker();
    }
    
    translate([- w / 2, 0, 0])
    difference() {
        translate([0, -led_length / 2, 0])
        union() {
            translate([0, -extra, 0])
            cube([w, led_length + extra * 2, meat]);

            translate([-meat, -extra, 0]) 
            cube([meat, led_length + extra * 2, h]);
            
            translate([-meat + w + meat, -extra, 0]) 
            cube([meat, led_length + extra * 2, h]);
        }
        
        led();
        
        translate([0, -led_length / 2 + 0.5, meat]) {
            rotate([0, 0, -360/28])
            translate([0, -t/2, 0])
            cube([20, t, h]);

            rotate([0, 0, -360/28+180])
            translate([0, -t/2, 0])
            cube([20, t, h]);
        }

        translate([0, led_length / 2 - 0.5, meat]) {
            rotate([0, 0, 360/28])
            translate([0, -t/2, 0])
            cube([20, t, h]);

            rotate([0, 0, 360/28+180])
            translate([0, -t/2, 0])
            cube([20, t, h]);
        }

        translate([-5, strip / 2, meat + 0.2 * 3]) {
            translate([0, -t/2, 0])
            cube([20, t, h]);
        }

        translate([-5, -strip / 2, meat + 0.2 * 3]) {
            translate([0, -t/2, 0])
            cube([20, t, h]);
        }
    }

    *color("black")
    translate([-w/2, -strip/2, 3])
    cube([w, strip, 2]);
}

*cut();

*translate([0, 0, 2])
led_strip();
