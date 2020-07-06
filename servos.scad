/**
 * Futaba S3003 servo
 *
 * @param vector position The position vector
 * @param vector rotation The rotation vector
 */
module servo_futabas3003(position, rotation, screw_diameter=0, screw_depth=10) {
/*	futabas3003=[
		['main',[
			["xx",123]
			,["yy",123]
			,["zz",123]
		]
		,['ear',[
		]
	];
*/
	servo(
		position
		, rotation
		, screw_diameter
		, screw_depth
		,servo_main_length=40.4 //39.9
		,servo_main_width=19.8 //20.1
		,servo_main_height=36
		,servo_axle_offset_y=10
		,servo_ear_base_depth=10
		,servo_ear_hole_radius=2.2
		,servo_ear_width=18
		,servo_ear_length=7.5
		,servo_ear_height=2.5
		,servo_ear_hole_cc_x=10
		,servo_ear_hole_cc_y=48.5
	);

}
/**
 * Origo: base of axle
 */
module servo(
	position
	, rotation
	, screw_diameter=0
	, screw_depth=10
	, servo_main_length=40.4 //39.9
	, servo_main_width=19.8 //20.1
	, servo_main_height=36

	, servo_axle_offset_y=10

	, servo_ear_base_depth=10
	, servo_ear_hole_radius=2.2
	, servo_ear_width=18
	, servo_ear_length=7.5
	, servo_ear_height=2.5
	, servo_ear_hole_cc_x=10
	,servo_ear_hole_cc_y=48.5
	) {

	translate(position)
	{
		rotate(rotation)
	    {
			union()
			{
				// Box
				translate([-servo_main_width/2,-servo_main_length/2+servo_axle_offset_y,-servo_main_height]) {
					//#sphere(2);
					// Main:
					cube([servo_main_width, servo_main_length, servo_main_height], false);
					
				}

				translate([0,servo_main_length/2+servo_axle_offset_y,-servo_ear_base_depth]) {
					//#sphere(2);
					servo_ear(
						servo_ear_width
						,servo_ear_length
						,servo_ear_height
						,servo_ear_hole_cc_x
						,/*servo_ear_hole_y=*/(servo_ear_hole_cc_y-servo_main_length)/2
						,servo_ear_hole_radius
						, screw_diameter
						, screw_depth
					);
				}

				translate([0,-servo_main_length/2+servo_axle_offset_y,-servo_ear_base_depth]) {
					//#sphere(2);
					mirror([0,1,0]) servo_ear(
						servo_ear_width
						,servo_ear_length
						,servo_ear_height
						,servo_ear_hole_cc_x
						,/*servo_ear_hole_y=*/(servo_ear_hole_cc_y-servo_main_length)/2
						,servo_ear_hole_radius
						, screw_diameter
						, screw_depth
					);
				}

				// Main axle
				translate([0, 0, 0])			{
					cylinder(r1=7,r2=5, h=0.4, $fn=30);
					cylinder(r=3, h=6, $fn=20);
				}
			}
		}
	}
}
module servo_ear(
	servo_ear_width
	,servo_ear_length
	,servo_ear_height
	,servo_ear_hole_cc_x
	,servo_ear_hole_y
	,servo_ear_hole_radius
	,screw_diameter=0
	,screw_depth=10
	) {
		difference() {
			translate([-servo_ear_width/2, 0, 0])
			cube([servo_ear_width, servo_ear_length, servo_ear_height]);
			translate([-servo_ear_hole_cc_x/2, servo_ear_hole_y, -1]) cylinder(h=servo_ear_height+2, r=servo_ear_hole_radius);
			translate([servo_ear_hole_cc_x/2, servo_ear_hole_y, -1]) cylinder(h=servo_ear_height+2, r=servo_ear_hole_radius);
		}
		if (screw_diameter > 0) {
			translate([-servo_ear_hole_cc_x/2, servo_ear_hole_y, -screw_depth]) cylinder(h=screw_depth*2+2.5, d=screw_diameter);
			translate([servo_ear_hole_cc_x/2, servo_ear_hole_y, -screw_depth]) cylinder(h=screw_depth*2+2.5, d=screw_diameter);
		}
}
