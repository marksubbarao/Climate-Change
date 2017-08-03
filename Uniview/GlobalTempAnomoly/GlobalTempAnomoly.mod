filepath +:./modules/GlobalTempAnomoly
			


object GlobalTempAnomoly sgOrbitalObject
{
	coord Earth
	geometry SG_USES GlobalTempAnomoly.conf
	scalefactor 655
	targetradius 300	
	cameraradius 30
	lsize 10000000
	guiName /Solar System/Planets/Earth/GlobalTempAnomoly/Earth tint
	off
}
object GlobalTempAnomolyGraph sgOrbitalObject
{
	coord Earth
	geometry SG_USES GlobalTempAnomolyGraph.conf
	scalefactor 655
	targetradius 300	
	cameraradius 30
	guiName /Solar System/Planets/Earth/GlobalTempAnomoly/Graph
	off
}

