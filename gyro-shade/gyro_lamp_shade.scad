/***************************** LICENSE *****************************
*                                                                  *
*    Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)    *
*    https://creativecommons.org/licenses/by-nc/4.0/               *
*                                                                  *
********************************************************************/

/*****************************************************************************
*                                                                            *
*    Created by Harald Andersson 2020-09-23                                  *
*                                                                            *
*    Originally uploaded at PrusaPrinters                                    *
*   https://www.prusaprinters.org/prints/41724-customizable-gyro-lamp-shade  *
*                                                                            *
******************************************************************************/

/******************** SAFETY ********************
*                                               *
*    When 3D printing lamp shades you should    *
*    always use a low energy LED light bulb     *
*    to minimize heat and use a temperature     *
*    resilient material for any parts close     *
*    to the light bulb.                         *
*                                               *
*************************************************/

/***************************************************************
*                                                              *
*            Requires OpenSCAD version 2019.05                 *
*    Newer versions (at the time of writing there are none)    *
*    should work unless they introduce any breaking changes    *
*                                                              *
****************************************************************/

// The dimensions set in the original file were used to create a lamp shade for an IKEA HEMMA cord set.

//////////////////////////    User parameters    //////////////////////////
// These are the parameters you can edit to customize the lamp shade
// All dimensions are in mm
// All comments below are single line to display properly in OpenSCAD Customizer.

// Set to true for a high resolution model. Must be set to true before rendering. Set to false for quicker preview when testing different parameters. Do not worry if the model looks broken when this is turned off.
highResolution = false;

$fs = highResolution ? 0.4 : 2;
$fa = highResolution ? 1 : 12;

// Control which parts to show and how to place and orient them. 0: Preview, all parts assembled. Only for visual representation. 1: All parts spread out (rings divided into two groups) and oriented for printing. Use this when exporting to get all parts in a single file. 2: Only even numbered rings. 3: Only odd numbered rings. 4: Only mounting plate. 5: Connector test pieces. Use this for quick testing of parameters for filament connectors.
renderMode = 0;

// Thickness of each ring
ringThickness = 2;

// The height of the rings. The height of the innermost ring if ringHeightStepping (below) is set.
ringHeight = 18;

// Difference in height between each ring starting at the innermost ring. Set to positive value to increase height, negative value to decrese height and zero to disable.
ringHeightStepping = 0;

// Distance between each ring
ringSpacing = 6;

// Inner diameter of the innermost ring
innerRingDiameter = 86;

// Maximum outer diameter of the outermost ring. Actual diameter might be smaller.
outerRingMaxDiameter = 200;

// Maximum size (on the x-y plane) of parts to be printed. Any rings with outer diameter greater than this value will be split into multiple parts which should be connected using filament pieces.
maxPrintSize = 200;

// Depth of holes to insert filament into when connecting parts of split rings.
splitConnectorHoleDepth = 5;

// Set to true to create a hole in the connectors to insert a piece of filament into. This will help the rings to stay connected if they are too thin and flexible for the cone shaped connectors alone. It is recommended to use this option.
useFilamentConnectors = true;

// Diameter of the hole in the connector which should hold the filament. Should be slightly larger than your filament diameter. Will also be used if any rings are split to multiple parts.
filamentConnectorDiameter = 2;

// Extra clearance for the hole in the inner ring which the filament will rotate in. Diameter of this hole will be filamentConnectorDiameter + 2 * filamentRotationClearance.
filamentRotationClearance = 0.1;

// Distance from the top of the lamp socket screw to the center of the rings.
socketTopToRingCenterDistance = 80;

// The maximum outer diameter of the nut used to fasten lamp shades to the socket.
socketNutMaxDiameter = 58;

// Diameter of the center hole in the mouning plate. Should be slightly larger that the outer diameter of the threads of the lamp socket.
mountingPlateCenterHoleDiameter = 40.4;

// Thickness of the mounting plate
mountingPlateThickness = 3;

// Thickness of the top plate. A thicker plate is recommended if the mount plate will be below the rings, e.g. for a table lamp.
topPlateThickness = 1;

// Size of gap between parts which should be inserted into each other to ensure easy assembly
mountClearance = 0.2;

// Minumum thickness (at the mounting plate) of the bars connecting the innermost ring to the mounting plate. A thicker bar is recommended if the mount plate will be below the rings, e.g. for a table lamp.
mountingBarTopMinimunThickness = 2;

// Width of the bars connecting the innermost ring to the mounting plate. A wider bar is recommended if the mount plate will be below the rings, e.g. for a table lamp.
mountingBarWidth = 6;

// Set to true to show a simple light bulb in render mode 0. Does not affect exported model.
showLightBulb = true;

// Diameter of the light bulb shown when renderMode is set to 0. Does not affect exported model.
lightBulbDiameter = 60;

// Color of the top plate in preview mode. Does not affect exported model.
topPlateColor = "LightGray";

// Color of the mounting plate in preview mode. Does not affect exported model.
mountingPlateColor = "Gray";

// Color of even numbered rings (starting with the innermost as 0) in preview mode. Does not affect exported model.
evenRingColor = "BurlyWood";

// Color of odd numbered rings (starting with the innermost as 0) in preview mode. Does not affect exported model.
oddRingColor = "Wheat";

// Color of the light bulbs glass in preview mode. Does not affect exported model.
lightBulbGlassColor = "Khaki";

// Color of the light bulbs screw in preview mode. Does not affect exported model.
lightBulbScrewColor = "Silver";

//////////////////////////    End user parameters    //////////////////////////

//////////////////////////    Private parameters. Do not touch.    //////////////////////////
// The variables initiated here are set using expressions to hide from OpenSCAD Customizer

numberOfRings = floor(( (outerRingMaxDiameter - innerRingDiameter) / 2 - ringThickness) / (ringThickness + ringSpacing)) + 1;

// Used to create a small overlap between some parts to make sure that boolean operations works properly
overlap = 0 + 0.1;

// Minimum width of mounting ring
minMountRingWidth = 0 + 3;

mountingBarTopDistanceFromCenter = mountingPlateCenterHoleDiameter / 2 + max((socketNutMaxDiameter - mountingPlateCenterHoleDiameter) / 2 + 1, minMountRingWidth) + mountingPlateThickness + 2 * mountClearance;

// Distance between parts of a split ring.
splitWidth = 0 + 0.1;

// Minimum distance between connection holes in a split ring.
splitConnectorHoleMinDistance = 0 + 3;

//////////////////////////    Functions    //////////////////////////

function minimumSpacing(innerRingRadius, innerRingHeight, innerRingThickness) =
    (innerRingRadius + innerRingThickness) / cos(atan(innerRingHeight / (2 * (innerRingRadius + innerRingThickness)))) - innerRingRadius - innerRingThickness;

function nextPowerOfTwo(n, p = 1) =
    let (result = pow(2, p)) result >= n ? result
    : nextPowerOfTwo(n, p + 1);

function getNumberOfParts(ringNumber) =
    let (ringOuterRadius = innerRingDiameter / 2 + (ringSpacing + ringThickness) * ringNumber + ringThickness) ringOuterRadius * 2 <= maxPrintSize ? 1
    : let (n = ceil(360 / (2 * asin(maxPrintSize / (2 * ringOuterRadius))))) nextPowerOfTwo(n);

//////////////////////////    Modules    //////////////////////////
module connector(radius, hole) {
    connectorLength = (
        ringThickness >= radius - 1 ? ringSpacing + radius
        : ringSpacing + ringThickness + 1
    ) + (
        useFilamentConnectors ? filamentConnectorDiameter / 2 - 2
        : (ringThickness + 1 >= radius ? -1 : 0)
    );
    module roundConn() {
        if (connectorLength > radius) {
            polygon([[0, -overlap], [radius, -overlap], [radius, 0], [radius, connectorLength - radius], [0, connectorLength]]);
        } else {
            polygon([[0, -overlap], [radius, -overlap], [radius, 0], [0, connectorLength]]);
        }
    }

    module flatBottom() {
        rCos45 = radius * cos(45);
        rSin45 = radius * sin(45);

        module p() {
            polygon([[-radius, 0], [-radius, rSin45 - (radius - rCos45)], [-rCos45, rSin45], [-rCos45, 0]]);
        }

        union() {
            p();
            mirror([0, 1, 0]) {
                p();
            }
        }
    }

    module filamentConnector() {
        diameter = hole ? filamentConnectorDiameter + 2 * filamentRotationClearance : filamentConnectorDiameter;
        translate([0, 0, overlap]) {
            cylinder(d=diameter, h=connectorLength + ringThickness + ringSpacing);
        }
    }

    module c() {
        if (connectorLength > radius) {
            union() {
                rotate_extrude() {
                    roundConn();
                }
                translate([0, 0, -overlap]) {
                    linear_extrude(connectorLength - radius + overlap) {
                        flatBottom();
                    }
                }
            }
        } else {
            rotate_extrude() {
                roundConn();
            }
        }
    }

    rotate([0, -90, 0]) {
        if (hole) {
            union() {
                c();
                if (useFilamentConnectors) {
                    filamentConnector();
                }
            }
        } else {
            difference() {
                c();
                if (useFilamentConnectors) {
                    filamentConnector();
                }
            }
        }
    }
}

module connectionCones(ringNumber) {
    xOffset = innerRingDiameter / 2 + (ringSpacing + ringThickness) * ringNumber;
    translate([xOffset, 0, 0]) {
        connector((ringHeight + ringHeightStepping * ringNumber) / 2, false);
    }
}

module connectionHoles(ringNumber) {
    xOffset = innerRingDiameter / 2 + (ringSpacing + ringThickness) * (ringNumber + 1);
    rotate(90) {
        translate([xOffset, 0, 0]) {
            connector((ringHeight + ringHeightStepping * (ringNumber + 1)) / 2, true);
        }
    }
}

module ring(ringNumber, outer) {
    xOffset = innerRingDiameter / 2 + (ringSpacing + ringThickness) * ringNumber;

    height = ringHeight + ringHeightStepping * ringNumber;
    module r() {
        rotate_extrude() {
            translate([xOffset, -height / 2]) {
                square([ringThickness, height]);
            }
        }
    }

    module c() {
        if (ringNumber > 0) {
            intersection() {
                union() {
                    connectionCones(ringNumber);
                    mirror([1, 0, 0]) {
                        connectionCones(ringNumber);
                    }
                }
                rotate_extrude() {
                    translate([0, -(height + 2 * overlap) / 2]) {
                        square([xOffset + ringThickness - overlap, height + 2 * overlap]);
                    }
                }
            }
        }
    }

    module h() {
        if (!outer) {
            connectionHoles(ringNumber);
            mirror([0, 1, 0]) {
                connectionHoles(ringNumber);
            }
        }
    }

    module bars() {
        module b() {
            length = socketTopToRingCenterDistance - topPlateThickness - mountingPlateThickness;
            module p() {
                translate([0, overlap, 0]) {
                    rotate([90, 0, 0]) {
                        linear_extrude(mountingBarWidth / 2 + overlap) {
                            union() {
                                polygon(
                                    [
                                        [0, 0],
                                        [mountingBarTopMinimunThickness, 0],
                                        [mountingPlateThickness + mountingBarTopMinimunThickness - mountClearance, mountingPlateThickness - mountClearance],
                                        [0, mountingPlateThickness - mountClearance],
                                    ]
                                );
                                bottomX = innerRingDiameter / 2 - mountingBarTopDistanceFromCenter - mountClearance;
                                polygon(
                                    [
                                        [0, 0],
                                        [bottomX, -length - ringHeight / 2],
                                        [bottomX + ringThickness, -length + ringHeight / 2],
                                        [mountingBarTopMinimunThickness, 0],
                                        [mountingBarTopMinimunThickness, overlap],
                                        [0, overlap],
                                    ]
                                );
                            }
                        }
                    }
                }
            }

            difference() {
                translate([mountingBarTopDistanceFromCenter + mountClearance, 0, length]) {
                    union() {
                        p();
                        mirror([0, 1, 0]) {
                            p();
                        }
                    }
                }
                rotate_extrude() {
                    translate([xOffset + ringThickness, -socketTopToRingCenterDistance]) {
                        square([xOffset, socketTopToRingCenterDistance * 2]);
                    }
                }
            }
        }

        rotate(90) {
            union() {
                b();
                mirror([1, 0, 0]) {
                    b();
                }
            }
        }
    }

    rz = ringNumber % 2 == 0 ? 0 : 90;
    rotate([0, 0, rz]) {
        difference() {
            union() {
                r();
                c();
                if (ringNumber == 0) {
                    bars();
                }
            }
            h();
        }
    }
}

module multiPartRing(ringNumber, outer, numParts) {
    ringInnerRadius = innerRingDiameter / 2 + (ringSpacing + ringThickness) * ringNumber;
    ringOuterRadius = ringInnerRadius + ringThickness;
    height = ringHeight + ringHeightStepping * ringNumber;
    extraThickness = filamentConnectorDiameter + 2 - ringThickness;
    connectionInnerRadius = extraThickness > 0 ? (ringInnerRadius - extraThickness + (extraThickness + ringThickness) / 2) : ringInnerRadius;
    connectionThickness = extraThickness > 0 ? ringThickness + extraThickness : ringThickness;
    module c() {
        // connector part to add extra thickness (if needed) to the ring
        if (extraThickness > 0) {
            a = 360 * (splitConnectorHoleDepth + 1) / connectionInnerRadius;
            rotate(180 / numParts - a / 2) {
                rotate_extrude(angle=a) {
                    translate([ringInnerRadius - extraThickness, -height / 2]) {
                        square([extraThickness + overlap, height]);
                    }
                }
            }
        }
    }

    module h() {
        // holes for filament
        a = 360 * (splitConnectorHoleDepth) / connectionInnerRadius;
        rotate(180 / numParts - a / 2) {
            rotate_extrude(angle=a) {
                n = (height - 4 + splitConnectorHoleMinDistance) / (filamentConnectorDiameter + splitConnectorHoleMinDistance);
                numHoles = max(floor(n), 1);
                for (i = [1:numHoles]) {
                    ty =
                        numHoles == 1 ? 0
                        : -height / 2 + 2 + filamentConnectorDiameter / 2 + ( (height - 4 - filamentConnectorDiameter) / (numHoles - 1)) * (i - 1);
                    translate([ringOuterRadius - connectionThickness / 2, ty]) {
                        circle(d=filamentConnectorDiameter);
                    }
                }
            }
        }
    }

    module s() {
        // splitter
        rotate(180 / numParts) {
            for (i = [0:numParts / 2 - 1]) {
                rotate(i * 360 / numParts) {
                    cube([ringOuterRadius * 2 + overlap * 2, splitWidth, height + overlap * 2], center=true);
                }
            }
        }
    }
    difference() {
        union() {
            ring(ringNumber, outer);
            for (i = [0:numParts - 1]) {
                rotate(i * 360 / numParts) {
                    c();
                }
            }
        }
        s();
        for (i = [0:numParts - 1]) {
            rotate(i * 360 / numParts) {
                h();
            }
        }
    }
}

module mountRing(thickness) {
    rotate_extrude() {
        translate([mountingPlateCenterHoleDiameter / 2, 0, 0]) {
            square([max((socketNutMaxDiameter - mountingPlateCenterHoleDiameter) / 2 + 1, minMountRingWidth), thickness]);
        }
    }
}

module mountEar(thickness) {
    module plate() {
        translate([mountingPlateCenterHoleDiameter / 2, -overlap, 0]) {
            cube(
                [
                    1.2 + 2 * mountingPlateThickness + mountingBarTopMinimunThickness + 2 * mountClearance + max((socketNutMaxDiameter - mountingPlateCenterHoleDiameter) / 2 + 1, minMountRingWidth),
                    mountingBarWidth / 2 + 3 + overlap,
                    thickness,
                ]
            );
        }
    }
    union() {
        plate();
        mirror([0, 1, 0]) {
            plate();
        }
    }
}

module mountingPlate() {
    module hole() {
        module p() {
            translate([0, overlap, 0]) {
                rotate([90, 0, 0]) {
                    linear_extrude(mountingBarWidth / 2 + mountClearance + overlap) {
                        polygon(
                            [
                                [0, -overlap],
                                [mountingPlateThickness + mountingBarTopMinimunThickness + 2 * mountClearance, -overlap],
                                [mountingPlateThickness + mountingBarTopMinimunThickness + 2 * mountClearance, 0],
                                [2 * mountingPlateThickness + mountingBarTopMinimunThickness + 2 * mountClearance, mountingPlateThickness],
                                [2 * mountingPlateThickness + mountingBarTopMinimunThickness + 2 * mountClearance, mountingPlateThickness + overlap],
                                [0, mountingPlateThickness + overlap],
                            ]
                        );
                    }
                }
            }
        }

        translate([mountingBarTopDistanceFromCenter - mountingPlateThickness - mountClearance, 0, 0]) {
            union() {
                p();
                mirror([0, 1, 0]) {
                    p();
                }
            }
        }
    }

    difference() {
        union() {
            mountRing(mountingPlateThickness);
            union() {
                mountEar(mountingPlateThickness);
                mirror([1, 0, 0]) {
                    mountEar(mountingPlateThickness);
                }
            }
        }
        hole();
        mirror([1, 0, 0]) {
            hole();
        }
    }
}

module topPlate() {
    module pin() {
        module p() {
            linear_extrude(mountingPlateThickness + overlap) {
                polygon(
                    [
                        [0, -overlap],
                        [mountingPlateThickness, -overlap],
                        [mountingPlateThickness, mountingBarWidth / 2],
                        [0, mountingBarWidth / 2],
                    ]
                );
            }
        }

        translate([mountingBarTopDistanceFromCenter - mountingPlateThickness, 0, -mountingPlateThickness]) {
            union() {
                p();
                mirror([0, 1, 0]) {
                    p();
                }
            }
        }
    }
    union() {
        mountRing(topPlateThickness);
        union() {
            mountEar(topPlateThickness);
            pin();
            mirror([1, 0, 0]) {
                mountEar(topPlateThickness);
                pin();
            }
        }
    }
}

module lightBulb() {
    union() {
        color(lightBulbScrewColor) {
            cylinder(h=lightBulbDiameter, d=lightBulbDiameter / 2);
        }
        color(lightBulbGlassColor) {
            sphere(d=lightBulbDiameter);
        }
    }
}

module testSplitConnectors() {
    thickness = max(filamentConnectorDiameter + 2, ringThickness);
    length = max(splitConnectorHoleDepth + 1, 10);
    height = ringHeight + ringHeightStepping * (numberOfRings - 1);
    n = (height - 4 + splitConnectorHoleMinDistance) / (filamentConnectorDiameter + splitConnectorHoleMinDistance);
    numHoles = max(floor(n), 1);
    module c() {
        translate([0, 0, -(ringHeight - height) / 2]) {
            rotate([90, 0, 90]) {
                difference() {
                    linear_extrude(length) {
                        square([thickness, height], center=true);
                    }
                    for (i = [1:numHoles]) {
                        ty =
                            numHoles == 1 ? 0
                            : -height / 2 + 2 + filamentConnectorDiameter / 2 + ( (height - 4 - filamentConnectorDiameter) / (numHoles - 1)) * (i - 1);
                        translate([0, 0, -overlap]) {
                            linear_extrude(splitConnectorHoleDepth + overlap) {
                                translate([0, ty]) {
                                    circle(d=filamentConnectorDiameter);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    c();
    translate([0, -thickness - 2, 0]) {
        c();
    }
}

//////////////////////////    Sanity checks    //////////////////////////
assert(numberOfRings > 0, "No rings can be created with the current parameters. Check the parameters outerRingMaxDiameter, innerRingDiameter and ringThickness");
assert(renderMode >= 0 && renderMode < 6, "Invalid render mode");
assert($preview || renderMode != 0, "Not allowed to render in mode 0 since it will produce an unprintable mesh. Please change render mode and try again");
assert(innerRingDiameter > socketNutMaxDiameter, "innerRingDiameter must be greater than socketNutMaxDiameter");
assert(ringHeight >= 4, "rightHeight too small");
assert(ringHeight + ringHeightStepping * (numberOfRings - 1) >= 4, "Too aggressive decreasing of ring height. Try changing ringHeight or ringHeightStepping");
assert($preview || highResolution, "set highResolution to true before rendering");
assert(ringThickness > 0, "ringThickness must be positive");
assert(ringSpacing > 0, "ringSpacing must be positive");
assert(filamentConnectorDiameter > 0, "filamentConnectorDiameter must be positive");
assert(filamentRotationClearance >= 0, "filamentRotationClearance can't be negative");
assert(socketTopToRingCenterDistance > 0, "socketTopToRingCenterDistance must be positive");
assert(mountingPlateThickness >= 3, "mountingPlateThickness should be at least 3");
assert(topPlateThickness >= 1, "mountingPlateThickness should be at least 1");
assert(mountingPlateCenterHoleDiameter > 0, "mountingPlateCenterHoleDiameter must be positive");
assert(mountingPlateCenterHoleDiameter < socketNutMaxDiameter, "mountingPlateCenterHoleDiameter must be smaller than socketNutMaxDiameter");
assert(mountClearance > 0, "mountClearance must be positive");
assert(mountingBarTopMinimunThickness >= 2, "mountingBarTopMinimunThickness should be at least 2");
assert((innerRingDiameter / 2 + ringThickness) >= mountingBarTopDistanceFromCenter + mountingBarTopMinimunThickness + mountingPlateThickness, "Try increasing innerRingDiameter or decreasing mountingBarTopMinimunThickness or mountingPlateThickness");
assert(mountingBarWidth >= 3, "mountingBarWidth should be at least 3");
assert(mountingBarWidth <= mountingPlateCenterHoleDiameter, "mountingBarWidth may not be greater than mountingPlateCenterHoleDiameter");
assert(maxPrintSize > 0, "maxPrintSize must be positive");
assert(splitConnectorHoleDepth >= 3, "splitConnectorHoleDepth should be at least 3");

// Check that rotation will be possible between all rings, abort if not
if (numberOfRings > 1) {
    for (i = [1:numberOfRings - 1]) {
        prevRingRadius = innerRingDiameter / 2 + (ringSpacing + ringThickness) * (i - 1);
        prevRingHeight = ringHeight + ringHeightStepping * (i - 1);
        minSpace = minimumSpacing(prevRingRadius, prevRingHeight, ringThickness);
        assert(ringSpacing >= minSpace, str("Too small spacing, rotation will be blocked between rings ", i - 1, " and ", i, ". Try increasing spacing or decreasing height. ringSpacing: ", ringSpacing, ", minimum space for rotation: ", minSpace));
    }
}

for (i = [0:numberOfRings - 1]) {
    height = ringHeight + ringHeightStepping * i;
    assert(filamentConnectorDiameter <= height - 3, "filamentConnectorDiameter too large");
}

if (outerRingMaxDiameter > maxPrintSize) {
    extraThickness = filamentConnectorDiameter + 2 - ringThickness;
    assert(extraThickness < ringSpacing, "Too small space for connectors for split rings. This can be fixed by increasing ringSpace or ringThickness or decreasing filamentConnectorDiameter or outerRingMaxDiameter");
}

//////////////////////////    Create the lamp shade    //////////////////////////

// Rings
if (renderMode < 4) {
    if (renderMode == 0) {
        for (i = [0:numberOfRings - 1]) {
            even = i % 2 == 0;
            c = even ? evenRingColor : oddRingColor;
            color(c) {
                numParts = getNumberOfParts(i);
                if (numParts > 1) {
                    multiPartRing(i, i == numberOfRings - 1, numParts);
                } else {
                    ring(i, i == numberOfRings - 1);
                }
            }
        }
    } else if (renderMode == 1) {
        for (i = [0:numberOfRings - 1]) {
            even = i % 2 == 0;
            c = even ? evenRingColor : oddRingColor;
            tx = even ? 0 : outerRingMaxDiameter;
            tz = (ringHeight + ringHeightStepping * i) / 2;
            color(c) {
                translate([tx, 0, tz]) {
                    numParts = getNumberOfParts(i);
                    if (numParts > 1) {
                        multiPartRing(i, i == numberOfRings - 1, numParts);
                    } else {
                        ring(i, i == numberOfRings - 1);
                    }
                }
            }
        }
    } else if (renderMode == 2) {
        for (i = [0:2:numberOfRings - 1]) {
            color(evenRingColor) {
                tz = (ringHeight + ringHeightStepping * i) / 2;
                translate([0, 0, tz]) {
                    numParts = getNumberOfParts(i);
                    if (numParts > 1) {
                        multiPartRing(i, i == numberOfRings - 1, numParts);
                    } else {
                        ring(i, i == numberOfRings - 1);
                    }
                }
            }
        }
    } else if (renderMode == 3) {
        for (i = [1:2:numberOfRings - 1]) {
            color(oddRingColor) {
                tz = (ringHeight + ringHeightStepping * i) / 2;
                translate([0, 0, tz]) {
                    numParts = getNumberOfParts(i);
                    if (numParts > 1) {
                        multiPartRing(i, i == numberOfRings - 1, numParts);
                    } else {
                        ring(i, i == numberOfRings - 1);
                    }
                }
            }
        }
    }
}

// Mount
if (renderMode == 0) {
    translate([0, 0, socketTopToRingCenterDistance - topPlateThickness - mountingPlateThickness + 10]) {
        rotate(90) {
            color(mountingPlateColor) {
                mountingPlate();
            }
            translate([0, 0, mountingPlateThickness + 10]) {
                color(topPlateColor) {
                    topPlate();
                }
            }
        }
    }
} else if (renderMode == 1) {
    tx = -mountingBarTopDistanceFromCenter + mountingPlateThickness + mountClearance - 1.2 - 2 * mountingPlateThickness - mountingBarTopMinimunThickness - 2 * mountClearance - outerRingMaxDiameter / 2 - 3;
    translate([tx, 0, 0]) {
        translate([0, -socketNutMaxDiameter / 2 - 2, mountingPlateThickness]) {
            translate([0, 0, -mountingPlateThickness]) {
                color(mountingPlateColor) {
                    mountingPlate();
                }
            }
        }
        translate([0, socketNutMaxDiameter / 2 + 2, topPlateThickness]) {
            rotate([180, 0, 0]) {
                color(topPlateColor) {
                    topPlate();
                }
            }
        }
    }
} else if (renderMode == 4) {
    translate([0, -socketNutMaxDiameter / 2 - 2, mountingPlateThickness]) {
        translate([0, 0, -mountingPlateThickness]) {
            color(mountingPlateColor) {
                mountingPlate();
            }
        }
    }
    translate([0, socketNutMaxDiameter / 2 + 2, topPlateThickness]) {
        rotate([180, 0, 0]) {
            color(topPlateColor) {
                topPlate();
            }
        }
    }
}

if (renderMode == 0 && showLightBulb) {
    %lightBulb();
}

if (renderMode == 5) {
    cubeThickness = 10;
    translate([0, ringHeight + 2, 0]) {
        union() {
            connector(ringHeight / 2, false);
            translate([cubeThickness / 2, 0, 0]) {
                cube([cubeThickness, ringHeight, ringHeight], center=true);
            }
        }
    }

    rotate(180) {
        translate([ringSpacing, 0, 0]) {
            union() {
                difference() {
                    translate([-ringThickness / 2 - ringSpacing, 0, 0]) {
                        cube([ringThickness, ringHeight, ringHeight], center=true);
                    }
                    connector(ringHeight / 2, true);
                }
                if (ringThickness < cubeThickness) {
                    height = min((ringHeight - filamentConnectorDiameter - filamentRotationClearance * 2) / 2, 3);
                    translate([-ringThickness / 2 - ringSpacing - cubeThickness / 2 + overlap / 2, 0, height / 2 - ringHeight / 2]) {
                        cube([cubeThickness - ringThickness + overlap, ringHeight, height], center=true);
                    }
                }
            }
        }
    }

    translate([0, -(max(filamentConnectorDiameter + 2, ringThickness) + ringHeight) / 2 - 2, 0]) {
        testSplitConnectors();
    }
}
