declare gforce_setpoint.
declare xAxis.
declare yAxis.
declare zAxis.
declare AoAarrow.
declare g.
declare accvec.
declare gforce.
declare Poutold.
declare Ii.
declare Di.
declare SP.
declare SP0.
declare SP1.
declare SP2.
declare PV.
declare Pout.
//declare Kp.
declare et.
declare etold.
declare p0.
declare counter.
declare counter2.
declare P.
declare I.
declare D.
declare a.
declare b.
declare c.
declare dt.
declare spctr.
declare counter3.
declare KV2.
declare et2.
declare Pout2.
declare a2.

set counter3 to 0.
set a to 0.91. //ku=4.55 tu=2.52
set b to ((5.46/2.52)).
set c to ((1.82*2.52)/3).
set dt to .01.
set a2 to 2.225.
//set et to (SP-KV).
//set Pout to ((Kp*et)+p0).
set p0 to ship:control:pilotmainthrottle.
set SP to (ship:airspeed*1.94384).
set counter to 0.
set counter2 to 0.
set Kp to 1.
set Ii to 1.
set Di to 0.
set spctr to 0.
set Poutold to ship:control:pilotmainthrottle.
set et2 to 0.
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
LOCK gforce TO accvec:MAG / g.

until counter > 1000000
{
	set a to 0.91.
	set b to ((5.46/2.52)).
	set c to ((1.82*2.52)/3).
	set Ii to 1.
	set Di to 0.

	set etold to et.
	wait dt.
	set KV to (ship:airspeed*1.94384).
	set et to ((SP-KV)).
	set D to ((et - etold)/dt).
	set I to -(I+et*dt).
		if abs(et*100) < 100			{
			set a to 2.275.
			set b to 0.
			set c to 0.
			set Di to 1.
						}
		if abs(b*I) > .002		{
			set a to 0.91.
			set b to ((5.46/2.52)).
			set c to ((1.82*2.52)/3).
			set Ia to 1. //PID
						}
		if abs(b*I) < .002	{
			set a to 3.64.
			set b to 0.
			set c to ((3.64*2.52)/8).
			set Ii to 2. //PD
					}

	set PV to ship:airspeed.
	set Pout to ((a*et) + (b*I) + (c*D)).

	if Pout > 1
		{set Pout to 1.}
	if Pout < 0
		{set Pout to 0.}

	set ship:control:pilotmainthrottle to Pout.

	if Pout >= 0 and Pout < .1 and et < 0 and Di = 0	//deploy
		{set spctr to spctr+1.}
	if Pout > .3 and Di = 0		//retract
		{set spctr to spctr-1.}
	if spctr > 5 and Di = 0
	{
			set counter2 to counter2+1.
			if counter2 = 30
			{
			//if ship:control:pilotmainthrottle = 0	{
			toggle AG3.
			set counter2 to 0.
			set spctr to 0.
			//					}
			}
	}
	if spctr < -25 and Di = 0
	{
		//if ship:control:pilotmainthrottle > 0
		//{
			toggle AG4.
			set spctr to 0.
		//	set counter2 to 0.
		//}
			//}
	}
//	if abs(spctr) = 100
//		{set spctr to 0.}

Set AoAarrow to vecdrawargs(
	V(0,0,0),
	SHIP:UP:VECTOR,
	RGB(1,0,0),
	"AOA",
	5.0,
	true	).

set xAxis to VECDRAWARGS( V(0,0,0), V(-1,0,0), RGB(1.0,0.5,0.5), "X axis", 10, TRUE ).
set yAxis to VECDRAWARGS( V(0,0,0), V(0,1,0), RGB(0.5,1.0,0.5), "Y axis", 10, TRUE ).
set zAxis to VECDRAWARGS( V(0,0,0), V(0,0,1), RGB(0.5,0.5,1.0), "Z axis", 10, TRUE ).

	if counter3 > 5
	{
   clearscreen.
   PRINT "Speed Desired".
   PRINT (SP).
   PRINT ".".
   PRINT "Actual Speed".
   PRINT (ship:airspeed*1.94384).
   PRINT " ".
   PRINT "Speed Error".
   PRINT -et*100.
   PRINT " ".
   PRINT "New Throttle".
   PRINT Pout.
   PRINT " ".
//   PRINT "P".
//   PRINT et.
//   PRINT " ".
//   PRINT "c*D".
//   PRINT D*c.
//   PRINT " ".
//   PRINT "b*I".
//   PRINT b*I.
//   PRINT " ".
//   PRINT "Spoiler Counter".
//   PRINT spctr.
//   PRINT " ".
   if Ii = 1 and Di = 0	{
	PRINT "System is PID".
	PRINT " ".
			}
   if Ii = 2 and Di = 0	{
	PRINT "System is PD".
	PRINT " ".
			}
   if Di = 1	{
	PRINT "System is P".
		}
   set counter3 to 0.
	}
set counter3 to counter3 + 1.
}