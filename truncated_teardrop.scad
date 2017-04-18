include <MCAD/teardrop.scad>;

module truncated_teardrop(radius, length) {
	translate([length/2, 0, 0])
	intersection() {
		teardrop(radius, length, angle=90);

		translate([-length/2, -radius, -radius])
			cube([length, 2*radius, 2*radius]);
	}
}
